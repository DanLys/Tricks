def make_spec(name:,
              dependencies:,
              source_dir: "Sources",
              resources: nil)

  Pod::Spec.new do |spec|
    spec.platform = :ios
    spec.ios.deployment_target = DEPLOYMENT_TARGET
    spec.name = name
    spec.version = '0.0.1-development'
    spec.author = {
      'Danil' => 'lyskin-2013@mail.ru'
    }
    spec.summary = "Generated podspec by template"
    spec.source = { "source": source_dir } 
    spec.license = "MyLic"
    spec.homepage = "MyPage"

    ################################ Dependencies
    dependencies.each { |dep| spec.dependency dep }

    ################################ Sources and headers
    unless source_dir.nil?
      spec.source_files = "#{source_dir}/**/*.{swift,h,m}"
      spec.public_header_files = "#{source_dir}/**/*.{h,modulemap}"
      spec.private_header_files = "#{source_dir}/**/YOSwiftHeader.h"
    end

    ################################ Resources

    if resources.is_a? String
      spec.resource_bundles = {
        name => [resources.to_s]
      }
    elsif resources.is_a? Array
      spec.resource_bundles = {
        name => resources
      }
    elsif resources.is_a? Hash
      spec.resource_bundles = resources
    end
  end
end
