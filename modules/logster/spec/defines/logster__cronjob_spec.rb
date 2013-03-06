require_relative '../../../../spec_helper'

describe 'logster::cronjob', :type => :define do
  let(:title) { 'giraffe' }
  let(:default_params) {{ :file => '/var/log/zebra.log' }}

  describe 'with default params' do
    let(:params) { default_params }

    it { should contain_cron('logster-cronjob-giraffe').with(
      :command => '/usr/sbin/logster --output=ganglia ExtendedSampleLogster /var/log/zebra.log',
    )}
  end

  describe 'with custom params' do
    let(:params) { default_params.merge({
      :parser => 'CamelLogster',
      :prefix => 'llama_',
    })}

    it { should contain_cron('logster-cronjob-giraffe').with(
      :command => '/usr/sbin/logster --output=ganglia --metric-prefix=llama_ CamelLogster /var/log/zebra.log',
    )}
  end
end
