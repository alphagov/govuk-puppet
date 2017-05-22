require_relative '../../../../spec_helper'

describe 'govuk_cdnlogs::transition_logs', :type => :class do
  let(:default_params) {{
    :log_dir          => '/tmp/logs',
    :private_ssh_key  => 'my key',
    :user             => 'logs_processor',
    :enabled          => true,
    :enable_cron      => true,
  }}

  context 'enabled set to true' do
    let(:params) { default_params }

    describe 'user' do
      it { is_expected.to contain_govuk_user('logs_processor').with({
        :ensure   => 'present',
        :fullname => 'Logs Processor',
      })}
    end

    describe 'SSH key' do
      it { is_expected.to contain_file('/home/logs_processor/.ssh/id_rsa').with_content('my key') }
    end

    describe 'git config' do
      it { is_expected.to contain_file('/home/logs_processor/.gitconfig') }
    end

    describe 'log processing config.yml' do
      it { is_expected.to contain_file('/tmp/logs/config.yml') }
    end

    describe 'processing script' do
      it { is_expected.to contain_file('/usr/local/bin/process_transition_logs.sh')
           .with_content(/LOGS_DIR='\/tmp\/logs'/)}
    end

    describe 'cron job' do
      it { is_expected.to contain_cron__crondotdee('process_transition_logs').with({
        :ensure  => 'present',
        :command => '/usr/local/bin/process_transition_logs.sh',
        :user    => 'logs_processor',
      }) }
    end
  end
end
