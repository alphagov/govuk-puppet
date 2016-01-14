require_relative '../../../../spec_helper'
require 'sshkey'

describe "users", :type => "class" do
  context 'on whitelisted node pentest user should be created' do
    let(:facts) {{ :hostname => 'foo' }}
    let(:pre_condition) { 'class users::andre_the_giant { govuk::user { "andre_the_giant": } }' }

    it { is_expected.to contain_govuk__user('andre_the_giant') }
  end

  context 'on non-whitelisted node pentest user should not be created' do
    let(:facts) {{ :hostname => 'bar' }}

    it { is_expected.not_to contain_govuk__user('andre_the_giant') }
  end
end


# Get a list of valid users from their manifest files
def user_list
  class_dir = File.expand_path("../../../manifests", __FILE__)
  Dir.glob("#{class_dir}/*.pp").collect { |user_manifest|
    user_manifest.gsub(/^#{class_dir}\/(.+)\.pp$/, '\1')
  }.delete_if { |username|
    username == 'init' or username == 'null_user'
  }
end

# Pre-existing accounts that don't follow the standard username form.
#
# We shouldn't be adding users to this list unless their username does not
# follow the standard form AND is their LDAP username
username_whitelist = %w{
  benilovj
  bob
  bradleyw
  elliot
  jackscotti
  jamiec
  tadast
}

user_list.each do |username|
  describe "users::#{username}", :type => "class" do
    it 'should have a username of the correct form' do
      user = subject.call.resource('govuk::user', username)
      expect(user).not_to be_nil

      unless username_whitelist.include?(username)
        uname_from_full = user[:fullname].downcase.gsub(/[^a-z]/i, '')
        uname_from_email = user[:email].split('@').first.gsub(/[^a-z]/i, '')

        expect(uname_from_full).to eq(uname_from_email), "name in fullname(#{user[:fullname]}) must match name in email(#{user[:email]})"
        expect(user[:name]).to eq(uname_from_full), "expected username '#{user[:name]}' to be '#{uname_from_full}' based on fullname and email"
      end
    end

  end
end
