require_relative '../../../../spec_helper'

describe 'nginx::package', :type => :class do
  context 'defaults' do
    let(:pre_condition) { 'service {"nginx":}' }

    it do
      is_expected.to contain_package('nginx-module-perl')
        .with_ensure('present')
        .that_notifies('Service[nginx]')
        .that_requires('Package[nginx]')

      is_expected.to contain_package('nginx')
        .with_ensure('1.14.0-1~trusty')
        .that_notifies('Service[nginx]')
    end
  end
  context 'nginx_version and nginx_module_perl_version set' do
    let (:params) {
      {
        :nginx_version => '1.12.0-1~trusty',
        :nginx_module_perl_version => '1.10.0-1~trusty'
      }
    }
    it do
      is_expected.to contain_package('nginx').with_ensure('1.12.0-1~trusty')
      is_expected.to contain_package('nginx-module-perl').with_ensure('1.10.0-1~trusty')
    end
  end
end
