#!/usr/bin/env ruby

require 'pathname'
require 'FileUtils'
require 'colorize'
require 'json'

COCOAPODS_CACHE = File.join(Dir.home, 'Library', 'Caches', 'Cocoapods', 'Pods')
SPECS = File.join(COCOAPODS_CACHE, 'Specs')
FILES = COCOAPODS_CACHE
PODSPEC_JSON_EXT = '.podspec.json'.freeze
DEPENDENCIES_DIR = File.join(Dir.pwd, 'Dependencies')

raise 'No COCOAPODS_CACHE' unless Dir.exist?(COCOAPODS_CACHE)

def install_pod(name)
  origin_podspec = File.join(SPECS, 'Release', name)
  origin_podspec = File.join(SPECS, 'External', name) unless Dir.exist?(origin_podspec)
  raise "Podspec cache for [#{name}] not found!" unless Dir.exist?(origin_podspec)

  podspec_jsons = Dir["#{origin_podspec}/*"]
                  .filter { |file| File.basename(file).end_with? PODSPEC_JSON_EXT }
  raise "Podspec.json file should be only one for [#{name}]. Found = [#{podspec_jsons}]" unless podspec_jsons.count == 1

  podspec_json = podspec_jsons.first
  pod_hash = File.basename(podspec_json, PODSPEC_JSON_EXT)

  pod_dir = File.join(DEPENDENCIES_DIR, name)
  FileUtils.rm_rf(pod_dir)
  FileUtils.mkdir_p(pod_dir)

  FileUtils.copy_entry(podspec_json, File.join(pod_dir, "#{name}#{PODSPEC_JSON_EXT}"))

  origin_pod_files = File.join(FILES, 'Release', name, pod_hash)
  origin_pod_files = File.join(FILES, 'External', name, pod_hash) unless Dir.exist?(origin_pod_files)
  raise "Pod files for #{name} not found!" unless Dir.exist?(origin_pod_files)

  FileUtils.copy_entry(origin_pod_files, pod_dir)

  puts "yo_pod '#{name}'".green
end

def all_cached_pods
  Dir.glob(File.join(SPECS, 'Release', '*'))
     .filter { |f| File.directory?(f) }
     .map { |f| File.basename(f) }
     .sort
end

# ----------- CLEANUP -------------

def remove_dynamic_and_tvos_frameworks
  puts "Removing dynamic and tvOS frameworks...".green
  
  FileUtils.rm_rf(File.join(DEPENDENCIES_DIR, 'YXMobileMetricaPush', 'dynamic'))
  FileUtils.rm_rf(File.join(DEPENDENCIES_DIR, 'YXMobileMetrica', 'dynamic'))

  Dir.glob(File.join(DEPENDENCIES_DIR, 'YXMobileMetrica', 'static', '*', 'tvos-arm64')).each do |dir|
    FileUtils.rm_rf(dir)
  end

  Dir.glob(File.join(DEPENDENCIES_DIR, 'YXMobileMetrica', 'static', '*', 'tvos-arm64_x86_64-simulator')).each do |dir|
    FileUtils.rm_rf(dir)
  end
end

def remove_unused_files
  puts "Removing unused files...".green
  
  FileUtils.rm_rf(File.join(DEPENDENCIES_DIR, 'FigmaExport', 'Release', 'figma-export_AndroidExport.bundle'))
  FileUtils.rm_rf(File.join(DEPENDENCIES_DIR, 'FigmaExport', 'Release', 'vd-tool'))
end

def fix_account_manager
  puts "Fix Account Manager podspec: set pod_target_xcconfig.DEFINES_MODULE = NO".green
  
  podspec_file_path = File.join(DEPENDENCIES_DIR, 'YXAccountManager', 'YXAccountManager.podspec.json')
  podspec_json = JSON.parse(File.read(podspec_file_path))
  podspec_json['pod_target_xcconfig']['DEFINES_MODULE'] = 'NO'
  File.write(podspec_file_path, JSON.pretty_generate(podspec_json))
end

# ----------- MAIN -------------

pods_to_be_installed = ARGV
pods_to_be_installed = all_cached_pods if pods_to_be_installed.empty?

raise 'Specify pods to be installed' if pods_to_be_installed.empty?

puts "Install these pods? Press any key or ctrl+c to cancel".yellow
pp pods_to_be_installed

STDIN.gets

pods_to_be_installed.each { |p| install_pod(p) }

remove_dynamic_and_tvos_frameworks
remove_unused_files
fix_account_manager

puts "Remove +x and pack symlinks...".green
exec './Scripts/update-deps-symlinks.sh'
