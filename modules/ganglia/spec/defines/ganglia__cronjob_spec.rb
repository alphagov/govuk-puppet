require_relative '../../../../spec_helper'

describe 'ganglia::cronjob', :type => :define do
  let(:title) { 'tiger' }
  let(:params) { {:content => 'tiger content'} }

  it do
    should contain_file('/etc/ganglia/scripts/tiger')
      .with_content('tiger content')
      .with_mode('0755')

    should contain_cron('ganglia-tiger')
      .with_command('/etc/ganglia/scripts/tiger')
      .with_minute('*')
      .with_user('root')
  end
end
