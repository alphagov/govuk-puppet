require_relative '../../../../spec_helper'

describe 'nginx::package', :type => :class do
  context 'defaults' do
    it do
      should contain_package('nginx-full').with(
        'ensure'  => 'present',
        'notify'  => 'Class[Nginx::Restart]',
        'require' => 'Package[nginx-common]',
      )
      should contain_package('nginx-common').with(
        'ensure'  => 'present',
        'notify'  => 'Class[Nginx::Restart]',
      )
      should contain_package('nginx').with_ensure('purged')
      should contain_class('govuk::ppa')
    end
  end
  context 'version set' do
    let (:params) { {:version => '1.4.4-precise1'} }
    it do
      should contain_package('nginx-full').with_ensure('1.4.4-precise1')
      should contain_package('nginx-common').with_ensure('1.4.4-precise1')
      should contain_package('nginx').with_ensure('purged')
    end
  end
  context 'nginx_package set' do
    let (:params) { {:nginx_package => 'nginx-extras'} }
    it do
      should contain_package('nginx-extras').with_ensure('present')
      should contain_package('nginx-common').with_ensure('present')
      should contain_package('nginx').with_ensure('purged')
    end
  end
  context 'nginx_package and version set' do
    let (:params) {
      {
        :nginx_package => 'nginx-light',
        :version       => '1.7-trusty1',
      }
    }
    it do
      should contain_package('nginx-light').with_ensure('1.7-trusty1')
      should contain_package('nginx-common').with_ensure('1.7-trusty1')
      should contain_package('nginx').with_ensure('purged')
    end
  end
end
