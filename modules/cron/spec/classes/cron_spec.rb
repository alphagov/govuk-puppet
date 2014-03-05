require_relative '../../../../spec_helper'

describe 'cron', :type => :class do
  it { should contain_service('cron').with_ensure('running') }
  it { should contain_file('/etc/default/cron').with_source('puppet:///modules/cron/etc/default/cron') }
end
