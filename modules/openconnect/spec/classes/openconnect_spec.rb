require_relative '../../../../spec_helper'

describe 'openconnect', :type => :class do
  let(:path_init)     { '/etc/init/openconnect.conf' }
  let(:path_passwd)   { '/etc/openconnect/network.passwd' }
  let(:default_params) {{
    :gateway  => '1.2.3.4',
    :user     => 'johnsmith',
    :password => 'password123',
  }}

  context 'with required params' do
    let(:params) { default_params }

    it { should contain_file(path_init) }
    it { should contain_file(path_passwd).with_content('password123') }

    it { should_not contain_file(path_init).with_content(/DNS_UPDATE/) }
    it { should_not contain_file(path_init).with_content(/--CAfile/) }
  end

  context 'with dnsupdate => yes' do
    let(:params) { default_params.merge({
      :dnsupdate  => 'yes',
    })}

    it { should contain_file(path_init).with_content(/DNS_UPDATE=yes/) }
  end
end
