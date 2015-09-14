require_relative '../../../../spec_helper'

describe 'govuk_jenkins::ssh_key', :type => :class do
  private_key_filename = '/var/lib/jenkins/.ssh/id_rsa'

  context 'when a keypair is not provided (by default)' do
    it { is_expected.to contain_exec('Creating key pair for jenkins').with_creates(private_key_filename) }
  end

  context 'when a keypair is provided' do
    let(:params) {{
      :private_key => '-----BEGIN KEY-----',
      :public_key  => 'AAAA',
    }}

    it { is_expected.to contain_file(private_key_filename).with_content('-----BEGIN KEY-----') }
    it { is_expected.to contain_file("#{private_key_filename}.pub").with_content('ssh-rsa AAAA') }
  end
end
