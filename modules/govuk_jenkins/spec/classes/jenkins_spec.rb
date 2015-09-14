require_relative '../../../../spec_helper'

describe 'govuk_jenkins', :type => :class do
  let(:ssh_dir) { '/var/lib/jenkins/.ssh' }
  let(:hiera_data) {{
    'govuk_jenkins::config::github_api_uri' => 'foo',
    'govuk_jenkins::config::github_client_id' => 'bar',
    'govuk_jenkins::config::github_client_secret' => 'baz',
    'govuk_jenkins::config::github_web_uri' => 'wibble',
  }}

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
