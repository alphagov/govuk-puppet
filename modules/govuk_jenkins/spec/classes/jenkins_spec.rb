require_relative '../../../../spec_helper'

describe 'govuk_jenkins', :type => :class do
  let(:ssh_dir) { '/var/lib/jenkins/.ssh' }

  let(:params) {{
    :apt_mirror_hostname => 'apt.example.com',
    :github_enterprise_cert => 'certcertcert',
    :github_enterprise_cert_path => 'wobble',
    :github_enterprise_hostname => 'dibble',
    :jenkins_home => 'bibble',
  }}

  it { is_expected.to contain_class('govuk_jenkins::ssh_key') }
  it { is_expected.to contain_class('govuk_jenkins::config') }
  it { is_expected.to contain_file(ssh_dir).with_ensure('directory') }

  it { is_expected.to contain_user('jenkins').with_ensure('present') }
end
