#!/usr/bin/env ruby
require 'fileutils'

def validate_args!
  usage unless ARGV.count == 5
  usage unless ARGV[0..1].all? {|p| File.directory?(p)}
  local_path = ARGV[1]
  usage unless ARGV[2..4].all? {|p| File.directory?(File.join(local_path, p))}
end

master_path, local_path, incoming_dir, clean_dir, infected_dir = ARGV

def usage
  $stderr.puts "USAGE: " + File.basename(__FILE__) +
  " <master_data_path> <slave_data_path> <incoming_dir> <clean_dir> <infected_dir>"
  $stderr.puts %{
PURPOSE:

Copies all files from master_data_path to slave_data_path and then cleans up
any files which may have moved directory due to virus scanning. Files present
in clean_dir will be removed from incoming_dir. Files present in infected_dir
will be removed from both incoming_dir and clean_dir.

}
  exit(1)
end

validate_args!

class Cleaner
  def initialize(local_dir)
    @local_dir = local_dir
  end

  def cleanup_origin_files(origin_dir, destination_dir)
    Dir["#{local_path_to(origin_dir)}/**/*"].each do |origin_file_path|
      next unless File.file?(origin_file_path)
      if file_exists_in_destination?(origin_file_path, origin_dir, destination_dir)
        FileUtils.rm origin_file_path
      end
    end
  end

  def local_path_to(dir)
    "#{@local_dir}/#{dir}"
  end

  def file_exists_in_destination?(origin_file_path, origin_dir, destination_dir)
    destination_file_path = origin_file_path.gsub(
        local_path_to(origin_dir), local_path_to(destination_dir))
    File.exist?(destination_file_path)
  end
end

def copy_files_from_master_to_slave(origin_path, destination_path)
  `/usr/bin/rsync -v -a #{origin_path}/. #{destination_path}`
end

copy_files_from_master_to_slave(master_path, local_path)
cleaner = Cleaner.new(local_path)
cleaner.cleanup_origin_files(clean_dir, infected_dir)
cleaner.cleanup_origin_files(incoming_dir, infected_dir)
cleaner.cleanup_origin_files(incoming_dir, clean_dir)
