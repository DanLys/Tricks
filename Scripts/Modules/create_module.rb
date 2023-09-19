#!/usr/bin/env ruby

require "FileUtils"
require "pathname"

class Find
  def file_location()
  end
end

class File
    def self.replace_substring(file_path, replace_math, new_string)
        content = File.read(file_path)
        File.write(file_path, content.gsub(replace_math, new_string))
    end
end

MODULE_NAME_PATTERN = "MODULE_NAME"
PODS_FOLDER_PATTERN = "PODS_FOLDER"
TEMPLATES_FILES_DIR_NAME = "TEMPLATESFORMODULES"

FILE_LOCATION = Find.instance_method(:file_location).source_location.first
CURRENT_DIR = Dir.pwd

TEMPLATES_DIR = File.expand_path(File
  .join(Pathname
    .new(FILE_LOCATION)
    .parent
    .parent
    .parent, "Modules", "_Templates"))

puts TEMPLATES_DIR

PODS_DIR = File.join(Pathname.new(TEMPLATES_DIR).parent.parent, "Pods")
puts PODS_DIR

DIRECTORIES_TO_CREATE = ["Resources", "Sources", "Tests"]
FILES_FROM_TEMPLATE = ["%s.podspec", "%s.xcworkspace"]
MODULE_NAME = ARGV[0]

unless ARGV[0]
    abort("need add name, when run script. Example: ./create_module.rb module_name")
end

module_dir = File.join(CURRENT_DIR, MODULE_NAME)
DIRECTORIES_TO_CREATE.each do |folder_name|
    folder_path = File.join(module_dir, folder_name)
    puts "Create directory with path: #{folder_path}"
    FileUtils.mkdir_p(folder_path)
end

FILES_FROM_TEMPLATE.each do |temp_file|
    from_path = File.join(TEMPLATES_DIR, temp_file % MODULE_NAME_PATTERN)
    to_path = File.join(module_dir, temp_file % MODULE_NAME)
    puts "Copy file from directory with path: #{from_path}"
    puts "Copy file to directory with path: #{to_path}"
    FileUtils.copy_entry(from_path, to_path)
end

podspec_path = File.join(module_dir, "#{MODULE_NAME}.podspec")
File.replace_substring(podspec_path, MODULE_NAME_PATTERN, MODULE_NAME)
puts "Podspec file are patched at path: #{podspec_path}"

xcworkspacedata_path = File.join(module_dir, "#{MODULE_NAME}.xcworkspace/contents.xcworkspacedata")
relative_pods_dir = Pathname.new(PODS_DIR).relative_path_from(Pathname.new(module_dir))
File.replace_substring(xcworkspacedata_path, MODULE_NAME_PATTERN, MODULE_NAME)
File.replace_substring(xcworkspacedata_path, PODS_FOLDER_PATTERN, relative_pods_dir.to_s)
puts "Xcworkspacedata file are patched at path: #{xcworkspacedata_path}"

TEMPLATES_FILES_DIR = File.join(TEMPLATES_DIR, TEMPLATES_FILES_DIR_NAME)
to_path = File.join(module_dir, DIRECTORIES_TO_CREATE[1])

Dir.children(TEMPLATES_FILES_DIR).each do |file|
  file_type = file.split(/\s|\./)[-1]

  if file_type == "DS_Store" || file_type == "xcodeproj"
    next
  end

  from_path = File.join(TEMPLATES_FILES_DIR, file)
  puts "Create file #{file} in Sources from #{from_path} to #{to_path}"
  FileUtils.copy_entry(from_path, to_path)
end
