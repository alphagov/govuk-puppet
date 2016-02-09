require_relative '../../../../spec_helper'

describe 'fail2ban::package', :type => :class do
  it { is_expected.to contain_package('fail2ban') }
end
