require "find"
require 'singleton'

def my_module(module_name, **rest)

  podspec_path = File.join(Dir.pwd,
              'Modules',
              'Screens',
              module_name,
              "#{module_name}.podspec")

  puts "--> Loading podspec from #{podspec_path}"

  pod module_name,
      path: File.dirname(podspec_path)
end
