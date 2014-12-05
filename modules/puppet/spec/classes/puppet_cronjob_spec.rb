require_relative '../../../../spec_helper'

describe 'puppet::cronjob', :type => :class do
  it 'should schedule regular puppet updates' do
    should contain_cron('puppet').
           with_ensure('present').
           with_command(/govuk_puppet/).
           with_user('root')
  end
end
