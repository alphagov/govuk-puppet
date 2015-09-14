require_relative '../../../../spec_helper'

describe 'fail2ban::service', :type => :class do
  it do
    is_expected.to contain_service('fail2ban')
  end
end
