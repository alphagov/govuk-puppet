require_relative '../../../../spec_helper'

# get the list of groups
def class_list
  if ENV["classes"]
    ENV["classes"].split(",")
  else
    class_dir = File.expand_path("../../../manifests/groups", __FILE__)
    Dir.glob("#{class_dir}/*.pp").collect { |dir|
      dir.gsub(/^#{class_dir}\/(.+)\.pp$/, 'users::groups::\1')
    }
  end
end

# Get a list of valid users from their manifest files
def user_list
  class_dir = File.expand_path("../../../manifests", __FILE__)
  Dir.glob("#{class_dir}/*.pp").collect { |user_manifest|
    user_manifest.gsub(/^#{class_dir}\/(.+)\.pp$/, '\1')
  }.delete_if { |username|
    username == 'init'
  }
end

# Get a list of all users who are present in a group class
def users_in_groups
  class_dir = File.expand_path("../../../manifests/groups", __FILE__)
  group_files = Dir.glob("#{class_dir}/*.pp")
  users_in_classes_list = []
  group_files.each do |group_filename|
    File.open(group_filename) do |file|
      file.each_line do |line|
        if line.match(/^  include/)
          users_in_classes_list << line.gsub(/^  include users::(.+)\n$/, '\1')
        end
      end
    end
  end

  users_in_classes_list
end

# this will throw a parse error if a user's manifest has been removed
# but they are still being included in a group
class_list.each do |group_class|
  describe group_class, :type => :class do
    it { should contain_class(group_class) }
  end
end

# Using the list of all manifests, make sure they're included
# in at least one group
group_list = users_in_groups
user_list.each do |username|
  describe username do
    it 'should be in at least one group' do
      group_list.should include(username)
    end
  end
end
