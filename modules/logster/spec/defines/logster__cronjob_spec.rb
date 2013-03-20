require_relative '../../../../spec_helper'

describe 'logster::cronjob', :type => :define do
  let(:title) { 'giraffe' }
  let(:facts) {{
    :fqdn => 'host.example.com',
    :fqdn_underscore => 'host_example_com',
  }}
  let(:graphite_host) { 'graphite.cluster:2003' }

  describe 'with default params' do
    let(:params) {{
      :file => '/var/log/zebra.log',
    }}

    it { should contain_cron('logster-cronjob-giraffe').with(
      :command => "/usr/sbin/logster --metric-prefix=host_example_com --output=graphite --graphite-host=#{graphite_host} ExtendedSampleLogster /var/log/zebra.log",
    )}
  end

  describe 'with custom params' do
    let(:params) {{
      :file => '/var/log/zebra.log',
      :parser => 'CamelLogster',
      :prefix => 'llama_',
    }}

    it { should contain_cron('logster-cronjob-giraffe').with(
      :command => "/usr/sbin/logster --metric-prefix=host_example_com.llama_ --output=graphite --graphite-host=#{graphite_host} CamelLogster /var/log/zebra.log",
    )}
  end
end
