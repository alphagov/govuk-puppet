require_relative '../../../../spec_helper'

describe 'fail2ban::config', :type => :class do
  it do
    should contain_file('/etc/fail2ban/fail2ban.local')
    should contain_file('/etc/fail2ban/jail.local')
  end
end
