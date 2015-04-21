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
        if line.match(/^ +include/)
          users_in_classes_list << line.gsub(/^ +include users::(.+)\n$/, '\1')
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

# Pre-existing accounts that don't follow the standard username form.
#
# We shouldn't be adding users to this list unless their username does not
# follow the standard form AND is their LDAP username
username_whitelist = %w{
  ajlanghorn
  alex_tea
  alext
  benilovj
  benp
  bob
  bradleyw
  dai
  dcarley
  elliot
  futurefabric
  heathd
  jabley
  jackscotti
  james
  jamiec
  kushalp
  minglis
  mwall
  niallm
  ollyl
  ppotter
  rthorn
  ssharpe
  tadast
  tekin
  vinayvinay
}

# Using the list of all manifests, make sure they're included
# in at least one group
group_list = users_in_groups

user_list.each do |username|
  describe "users::#{username}", :type => "class" do
    it 'should have a username of the correct form' do
      user = subject.resource('govuk::user', username)
      expect(user).not_to be_nil

      unless username_whitelist.include?(username)
        uname_from_full = user[:fullname].downcase.gsub(/[^a-z]/i, '')
        uname_from_email = user[:email].split('@').first.gsub(/[^a-z]/i, '')

        expect(uname_from_full).to eq(uname_from_email), "name in fullname(#{user[:fullname]}) must match name in email(#{user[:email]})"
        expect(user[:name]).to eq(uname_from_full), "expected username '#{user[:name]}' to be '#{uname_from_full}' based on fullname and email"
      end
    end

    it 'should be in at least one group' do
      group_list.should include(username)
    end
  end
end
