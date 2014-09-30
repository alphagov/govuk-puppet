require_relative '../../../../spec_helper'

describe 'govuk_jenkins', :type => :class do
  let(:ssh_dir) { '/var/lib/jenkins/.ssh' }

  let(:params) {{
    :github_enterprise_cert => 'certcertcert',
  }}

  it { should contain_class('govuk_jenkins::ssh_key') }
  it { should contain_file(ssh_dir).with_ensure('directory') }

  it { should contain_user('jenkins').with_ensure('present') }
end
