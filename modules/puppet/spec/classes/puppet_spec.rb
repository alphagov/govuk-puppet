require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  it { should create_package("puppet").with_ensure('2.7.3').with_provider('gem') }
  it 'should schedule regular puppet updates' do
    should create_cron('puppet').
           with_ensure('present').
           with_command(/puppet agent/).
           with_command(/--onetime/).
           with_command(/--no-daemonize/).
           with_user('root')
  end
end
