require_relative '../../../../spec_helper'

describe 'statsd', :type => :class do
  it { should contain_class('nodejs') }
  it { should contain_package('statsd') }
  it { should contain_file('/etc/statsd.conf') }
  it { should contain_file('/etc/init/statsd.conf') }
  it { should contain_service('statsd') }
end
