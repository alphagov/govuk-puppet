require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it { should contain_file('/etc/init/puppetmaster.conf') }
  it { should contain_service('puppetmaster').with_provider('upstart').with_ensure('running').with_require('File[/etc/init/puppetmaster.conf]') }
end
