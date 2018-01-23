require_relative '../../../../spec_helper'

describe 'govuk_logging::logstream', :type => :define do
  # Even though we no longer use the default_shipper in logstream, keep it here to test that
  # it is absent
  let(:default_shipper) { 'redis,\$REDIS_SERVERS,key=logs,bulk=true,bulk_index=logs-current' }
  let(:default_filters) { 'init_json,add_timestamp,add_source_host' }
  let(:title) { 'giraffe' }
  let(:facts) {{ :fqdn => 'camel.example.com' }}

  let(:log_file) { '/var/log/elephant.log' }
  let(:upstart_conf) { '/etc/init/logstream-giraffe.conf' }

  context 'with ensure set to absent' do
    let(:params) { {
      :logfile       => log_file,
      :ensure        => 'absent',
      } }
    it 'should ensure the upstart configuration is absent' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure => 'absent',
      )
    end

    it 'should ensure the service is stopped' do
      is_expected.to contain_exec('logstream-STOP-giraffe').with(
        :command => 'initctl stop logstream-giraffe || echo \'already stopped\'',
      )
    end
  end

  context 'with invalid ensure args' do
    context 'ensure => true' do
      let(:params) { {
        :logfile => log_file,
        :ensure  => 'true',
      } }
      it 'should fail validation' do
        is_expected.to raise_error(Puppet::Error, /validate_re/)
      end
    end
    context 'ensure => false' do
      let(:params) { {
        :logfile => log_file,
        :ensure  => 'false',
      } }
      it 'should fail validation' do
        is_expected.to raise_error(Puppet::Error, /validate_re/)
      end
    end
  end

  context 'statsd_timer and statsd_metric are not defined' do
    let(:params) { {
      :logfile => log_file,
      :ensure  => 'present',
    } }

    it 'should ensure the upstart configuration is absent' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure => 'absent',
      )
    end

    it 'should ensure the service is stopped' do
      is_expected.to contain_exec('logstream-STOP-giraffe').with(
        :command => 'initctl stop logstream-giraffe || echo \'already stopped\'',
      )
    end
  end

  context 'with statsd counter shipper specified' do
    let(:params) { {
      :logfile       => log_file,
      :ensure        => 'present',
      :statsd_metric => 'tom_jerry.foo.%{bar}',
    } }

    it 'should pass statsd_counter arg' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f init_json,add_timestamp,add_source_host -s statsd_counter,metric=tom_jerry.foo.%{bar}$/,
      )
    end
    it 'should not contain any configuration related to logs or redis' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure => 'present').without_content(/#{default_shipper}/)
    end
  end

  context 'with statsd timers specified' do
    let(:params) { {
      :logfile       => log_file,
      :ensure        => 'present',
      :statsd_timers => [{'metric' => 'tom_jerry.foo','value' => 'foo'},
                         {'metric' => 'tom_jerry.bar','value' => 'bar'}],
    } }

    it 'should pass statsd_timer arg' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f init_json,add_timestamp,add_source_host -s statsd_timer,metric=tom_jerry.foo,timed_field=foo statsd_timer,metric=tom_jerry.bar,timed_field=bar$/,
      )
    end
    it 'should not contain any configuration related to logs or redis' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure => 'present').without_content(/#{default_shipper}/)
    end
  end

  context 'with tags => Array' do
    let(:params) { {
      :logfile => log_file,
      :ensure  => 'present',
      :tags    => ['zebra', 'llama'],
      :statsd_metric => 'tom_jerry.foo.%{bar}',
    } }

    it 'should pass add_tags with list in filter chain' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f #{default_filters},add_tags:zebra:llama -s statsd_counter,metric=tom_jerry.foo.%{bar}$/,
      )
    end
  end

  context 'with fields => Hash' do
    let(:params) { {
      :logfile => log_file,
      :ensure  => 'present',
      :fields  => {'zebra' => 'stripey', 'llama' => 'fluffy'},
      :statsd_metric => 'tom_jerry.foo.%{bar}',
    } }

    it 'should pass --fields with kv pairs' do
      is_expected.to contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f #{default_filters},add_fields:zebra=stripey:llama=fluffy -s statsd_counter,metric=tom_jerry.foo.%{bar}$/,
      )
    end
  end
end
