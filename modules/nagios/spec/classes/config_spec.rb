require_relative '../../../../spec_helper'

describe 'nagios::config', :type => :class do
  it { should contain_file('/etc/nagios3') }
end
