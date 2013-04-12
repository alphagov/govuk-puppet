require_relative '../../../../spec_helper'

describe 'govuk::logstream', :type => :define do
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
        :content => /^\s+tail -F \/var\/log\/elephant\.log \| govuk_logpipe/,
      )
    end

    it 'should pass appropriate CLI args' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| govuk_logpipe --source-host camel.example.com$/,
      )
    end
  end

  context 'with tags => Array' do
    let(:params) { {
      :logfile => log_file,
      :enable  => true,
      :tags    => ['zebra', 'llama'],
    } }

    it 'should pass --tags with list' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| govuk_logpipe --source-host camel.example.com -t zebra llama$/,
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
        :content => /\| govuk_logpipe --source-host camel.example.com -f zebra=stripey llama=fluffy$/,
      )
    end
  end

  context 'with source_host => orangutan.zoo.com' do
    let(:params) { {
      :logfile     => log_file,
      :enable      => true,
      :source_host => 'orangutan.zoo.com',
    } }

    it 'should pass --fields with correct host kv' do
      should contain_file(upstart_conf).with(
        :ensure  => 'present',
        :content => /\| govuk_logpipe --source-host orangutan.zoo.com$/,
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
        :content => /\| govuk_logpipe --json --source-host camel.example.com$/,
      )
    end
  end
end
