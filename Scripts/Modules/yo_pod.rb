require 'singleton'
require 'json'
require 'set'

def yo_pod(module_name, version=nil, **rest)
  unless version.nil?
    load_pod(module_name, version)
    return
  end
  
  dependencies = PodDependencies.instance.build_dependencies_list(module_name)

  # убираем подспеки той подки, которую подключаем.
  dependencies.reject! { |dep| dep.normalized_pod_name == module_name.normalized_pod_name }
  
  # убираем из зависимостей внешние подки (те, что скачиваются из сети и имеют фиксированную версию)
  dependencies.reject! { |dep| PodDependencies.instance.external_pods.include? dep.normalized_pod_name }

  # убираем подспеки одной и той же подки: они подключатся сами, достаточно одной.
  # Но при этом всю подку подключать нельзя: default_subpecs могут быть тяжелые и/или неподдерживаемые
  dependencies.uniq! { |dep| dep.normalized_pod_name }
  
  unless load_pod(module_name, rest)
    puts "**> Skip loading pod #{module_name} with dependencies: #{dependencies}".yellow
    return
  end
  
  if rest[:skip_loading_dependencies] == true
    puts "**> Skip loading pod's #{module_name} dependencies: #{dependencies}".yellow
  else
    puts "==> Loading pod #{module_name} with dependencies: #{dependencies}".green  
    dependencies.each(&method(:load_pod))
  end
end

####################################### Private

class String
  def normalized_pod_name
    split('/').first
  end
end

class PodDependencies
  include Singleton
  
  attr_reader :external_pods
  
  def initialize
    @external_pods = [].to_set
  end

  def build_dependencies_list(pod_name)
    @build_dependencies_list_cache ||= Hash.new do |hash, key_pod_name|
      dependencies = build_direct_dependency_list key_pod_name
      hash[key_pod_name] = (dependencies + dependencies.flat_map(&method(:build_dependencies_list))).uniq.sort
    end

    @build_dependencies_list_cache[pod_name]
  end

  def relative_dependencies_path
    current_path = Dir.pwd
    @relative_modules_path_cache ||= Hash.new do |hash, key_current_path|
      self_path = self.class.instance_method(self.class.instance_methods.first).source_location.first
      modules_path = File.join(Pathname(self_path).parent.parent.parent.to_s, "Dependencies")
      relative_path = Pathname.new(modules_path).relative_path_from(key_current_path).to_s

      hash[key_current_path] = relative_path
    end
    
    @relative_modules_path_cache[current_path]
  end
  
  private
  
  def build_direct_dependency_list(pod_name)
    subspec_in_pod_name = pod_name.split('/')[1]

    @json_storage ||= Hash.new do |hash, key_pod_name|
      podspec_json_path = "#{relative_dependencies_path}/#{key_pod_name}/#{key_pod_name}.podspec.json"
      raise "Podspec json file not found: #{key_pod_name}.podspec.json at #{podspec_json_path}" unless File.file?(podspec_json_path)
      hash[key_pod_name] = JSON.parse(File.read(podspec_json_path))
    end

    podspec_json = @json_storage[pod_name.normalized_pod_name]

    direct_dependencies = (podspec_json['dependencies'] || {}).keys
    platform_direct_dependencies = ((podspec_json['ios'] || {})['dependencies'] || {}).keys

    subspecs_to_parse = (subspec_in_pod_name.nil? ? nil : [subspec_in_pod_name])
    subspecs_to_parse ||= Array(podspec_json['default_subspecs']).flatten
    subspecs_to_parse = nil if subspecs_to_parse.empty?
    subspecs_to_parse ||= podspec_json['subspecs'].map { |s| s['name'] } if podspec_json.key? 'subspecs'
        
    unless subspecs_to_parse.nil?
      subspec_deps = subspecs_to_parse.map do |subspec|
        subspec_descr = (podspec_json['subspecs'] || {}).detect { |s| s['name'] == subspec }
        subspec_descr ||= {}
        (subspec_descr['dependencies'] || {}).keys
      end.flatten
    end

    direct_dependencies + platform_direct_dependencies + (subspec_deps || [])
  end
end

def load_pod(module_name, version=nil, **rest)
  return false unless should_install_pod(rest)
  
  parameters = {
    :inhibit_warnings => true,
    :path => "#{PodDependencies.instance.relative_dependencies_path}/#{module_name.normalized_pod_name}"
  }.merge(rest)
  
  unless version.nil?
    parameters.delete(:path)
    PodDependencies.instance.external_pods.add(module_name.normalized_pod_name)
    puts "!!> Loading pod #{module_name} [v.#{version}] from Network!".red
  end
  parameters.delete(:disable_in_development_env)
  parameters.delete(:skip_loading_dependencies)
  
  # puts "⚡️-yo_pod pod #{module_name} [#{version}], parameters: #{parameters}".magenta
  if version.nil?
    pod module_name, parameters
  elsif
    pod module_name, version, parameters
  end
  
  return true
end
