require_relative '../../../../spec_helper'

describe 'govuk_gor', :type => :class do
  let(:args_default) {{
    '-input-raw'          => 'localhost:7999',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{
      'args' => args_default,
    }}

    it { is_expected.to contain_class('gor').with_service_ensure('stopped') }
    it { is_expected.to contain_govuk_logging__logstream('gor_upstart_log').with_ensure('absent') }
  end

  context '#enable' do
    let(:params) {{
      'args' => args_default,
      :enable => true,
    }}
    let(:facts) {{
      'data_sync_in_progress' => false,
    }}

    it { is_expected.to contain_govuk_logging__logstream('gor_upstart_log').with_ensure('present') }

    it {
      is_expected.to contain_class('gor').with(
        :service_ensure => 'running',
        :args           => args_default
      )
    }
  end

  context 'enabled but datasync in progress' do
    let(:params) {{
      'args' => args_default,
      :enable => true,
    }}
    let(:facts) {{
      'data_sync_in_progress' => true,
    }}

    it { is_expected.to contain_govuk_logging__logstream('gor_upstart_log').with_ensure('absent') }

    it {
      is_expected.to contain_class('gor').with(
        :service_ensure => 'stopped',
      )
    }
  end

  context 'enabled but datasync not in progress' do
    let(:params) {{
      'args' => args_default,
      :enable => true,
    }}
    let(:facts) {{
      'data_sync_in_progress' => false,
    }}

    it { is_expected.to contain_govuk_logging__logstream('gor_upstart_log').with_ensure('present') }

    it {
      is_expected.to contain_class('gor').with(
        :service_ensure => 'running',
      )
    }
  end
end
