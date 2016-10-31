require_relative '../../../../spec_helper'
require 'sshkey'

describe "users", :type => "class" do
  context 'on whitelisted node pentest user should be created' do
    let(:facts) {{ :hostname => 'foo' }}
    let(:pre_condition) { 'class users::andre_the_giant { govuk_user { "andre_the_giant": } }' }

    it { is_expected.to contain_govuk_user('andre_the_giant') }
  end

  context 'on non-whitelisted node pentest user should not be created' do
    let(:facts) {{ :hostname => 'bar' }}

    it { is_expected.not_to contain_govuk_user('andre_the_giant') }
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
  bob
}

user_list.each do |username|
  describe "users::#{username}", :type => "class" do
    it 'should have a username of the correct form' do
      user = subject.call.resource('govuk_user', username)
      expect(user).not_to be_nil

      unless username_whitelist.include?(username)
        uname_from_full = user[:fullname].downcase.gsub(/[^a-z]/i, '')
        uname_from_email = user[:email].split('@').first.gsub(/[^a-z]/i, '')

        expect(uname_from_full).to eq(uname_from_email), "name in fullname(#{user[:fullname]}) must match name in email(#{user[:email]})"
        expect(user[:name]).to eq(uname_from_full), "expected username '#{user[:name]}' to be '#{uname_from_full}' based on fullname and email"
      end
    end

    it 'should have a strong SSH key' do
      user = subject.call.resource('govuk_user', username)
      ssh_keys = user[:ssh_key]

      # Support for multiple SSH keys
      unless ssh_keys.is_a? Array
        ssh_keys = [ssh_keys].compact
      end

      ssh_keys.each do |key|
        if key != 'ssh-rsa REPLACE ME'
          key_strength = SSHKey.ssh_public_key_bits key
          expect(key_strength).to be >= 4096, "SSH key for #{user[:name]} is only #{key_strength} bits and must be stronger"
        end
      end
    end
  end
end
