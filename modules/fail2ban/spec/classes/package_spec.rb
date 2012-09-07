require_relative '../../../../spec_helper'

describe 'fail2ban::package', :type => :class do
  it { should contain_package('fail2ban') }
end
