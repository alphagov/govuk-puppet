require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it do
    should contain_file('/etc/init/puppetmaster.conf').
      with_content(/unicornherder -u unicorn -p \$PIDFILE -- -p 9090 -c \/etc\/puppet\/unicorn.conf/)
    should contain_service('puppetmaster').with_provider('upstart').with_ensure('running')
  end

  it { should contain_class('puppetdb') }
  it { should contain_class('puppet::master::nginx') }

  it do
    should contain_class('puppet::master::config')
    should contain_file('/etc/puppet/config.ru')
    should contain_package('puppet-common').with_ensure('2.7.22-1puppetlabs1')
    should contain_package('puppet').with_ensure('2.7.22-1puppetlabs1')
  end

  context "pass puppet_version for puppet packages" do
    let (:params) {{ 'puppet_version' => '1.2.3-puppetlabs-456' }}
    it do
      should contain_package('puppet-common').with_ensure('1.2.3-puppetlabs-456')
      should contain_package('puppet').with_ensure('1.2.3-puppetlabs-456')
    end
  end
end
