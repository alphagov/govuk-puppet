require_relative '../../../../spec_helper'

describe 'cron', :type => :class do
  it { should contain_service('cron').with_ensure('running') }
end
