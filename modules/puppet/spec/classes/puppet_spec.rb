require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  let(:facts) { { :govuk_class => 'test', :govuk_platform => 'production' } }

  it { should contain_file('/etc/puppet/puppet.conf') }
  it { should contain_package("puppet").with_provider('gem') }
  it 'should schedule regular puppet updates' do
    should contain_cron('puppet').
           with_ensure('present').
           with_command(/puppet agent/).
           with_command(/--onetime/).
           with_command(/--no-daemonize/).
           with_user('root')
  end
end
