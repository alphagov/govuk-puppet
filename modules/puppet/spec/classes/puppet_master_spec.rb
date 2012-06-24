require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  it { should contain_file('/etc/init/puppetmaster.conf').with_require('Package[puppet]') }
  it { should contain_service('puppetmaster').with_provider('upstart').with_ensure('running').with_require('File[/etc/init/puppetmaster.conf]') }
end
