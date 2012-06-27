require_relative '../../../../spec_helper'

describe 'nagios::install', :type => :class do
  it { should contain_package('nagios3') }
  it { should contain_file('/etc/nagios3/nagios.cfg') }
end
