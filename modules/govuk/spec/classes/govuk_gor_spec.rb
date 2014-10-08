require_relative '../../../../spec_helper'

describe 'govuk::gor', :type => :class do
  let(:host_staging) { 'www-origin-staging.production.alphagov.co.uk' }
  let(:args_default) {{
    '-input-raw'          => 'localhost:7999',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{
      'args' => args_default,
    }}

    it { should contain_class('gor').with_service_ensure('stopped') }
    it { should contain_govuk__logstream('gor_upstart_log').with_ensure('absent') }
  end

  context '#enable' do
    let(:params) {{
      'args' => args_default,
      :enable => true,
    }}

    it { should contain_govuk__logstream('gor_upstart_log').with_ensure('present') }

    it {
      should contain_class('gor').with(
        :service_ensure => 'running',
        :args           => args_default
      )
    }
  end
end
