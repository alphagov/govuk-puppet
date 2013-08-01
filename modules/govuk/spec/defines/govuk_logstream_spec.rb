require_relative '../../../../spec_helper'

describe 'govuk::logstream', :type => :define do
  let(:default_shipper) { 'redis,\$REDIS_SERVERS,key=logs,bulk=true,bulk_index=logs-current' }
  let(:default_filters) { 'init_txt,add_timestamp,add_source_host' }
  let(:title) { 'giraffe' }
  let(:facts) {{ :fqdn => 'camel.example.com' }}

  let(:log_file) { '/var/log/elephant.log' }
  let(:upstart_conf) { '/etc/init/logstream-giraffe.conf' }

  context 'with default args, enable => true' do
    let(:params) { {
      :logfile => log_file,
      :enable  => true,
    } }

    it 'should tail correct logfile' do
      should contain_file(upstart_conf).with(
        :content => /^\s+tail -F \/var\/log\/elephant\.log \| logship/,
      )
    end

    it 'should pass appropriate CLI args' do
      should contain_file(upstart_conf).with(
        :content => /\| logship -f #{default_filters} -s #{default_shipper}$/,
      )
    end

  end

  context 'with tags => Array' do
    let(:params) { {
      :logfile => log_file,
      :enable  => true,
      :tags    => ['zebra', 'llama'],
    } }

    it 'should pass add_tags with list in filter chain' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f #{default_filters},add_tags:zebra:llama -s #{default_shipper}$/,
      )
    end
  end

  context 'with fields => Hash' do
    let(:params) { {
      :logfile => log_file,
      :enable  => true,
      :fields  => {'zebra' => 'stripey', 'llama' => 'fluffy'},
    } }

    it 'should pass --fields with kv pairs' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f #{default_filters},add_fields:zebra=stripey:llama=fluffy -s #{default_shipper}$/,
      )
    end
  end

  context 'with json => true' do
    let(:params) { {
      :logfile => log_file,
      :enable  => true,
      :json    => true,
    } }

    it 'should pass --json arg' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f init_json,add_timestamp,add_source_host -s #{default_shipper}$/,
      )
    end
  end

  context 'with statsd counter shipper specified' do
    let(:params) { {
      :logfile       => log_file,
      :enable        => true,
      :json          => true,
      :statsd_metric => 'tom_jerry.foo.%{@fields.bar}',
    } }

    it 'should statsd_counter arg' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| logship -f init_json,add_timestamp,add_source_host -s #{default_shipper} statsd_counter,metric=tom_jerry.foo.%{@fields.bar}$/,
      )
    end
  end
end
