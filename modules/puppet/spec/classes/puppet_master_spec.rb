require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it do
    should contain_file('/etc/init/puppetmaster.conf')
    should contain_service('puppetmaster').with_provider('upstart').with_ensure('running')
  end

  it { should contain_class('puppetdb') }
  it { should contain_class('puppet::master::nginx') }

  it do
    should contain_class('puppet::master::config')
    should contain_file('/etc/puppet/config.ru')
  end
end
