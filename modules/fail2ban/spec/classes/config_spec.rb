require_relative '../../../../spec_helper'

describe 'fail2ban::config', :type => :class do
  it do
    should contain_file('/etc/fail2ban/fail2ban.conf')
    should contain_file('/etc/fail2ban/jail.conf')
  end
end
