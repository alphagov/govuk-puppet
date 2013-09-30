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

# this will throw a parse error if a user's manifest has been removed
# but they are still being included in a group
class_list.each do |group_class|
  describe group_class, :type => :class do
    it { should contain_class(group_class) }
  end
end
