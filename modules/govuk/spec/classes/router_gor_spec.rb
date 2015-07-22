require_relative '../../../../spec_helper'

describe 'router::gor', :type => :class do
  let(:staging_host) { 'replay-target' }
  let(:staging_ip) { '127.0.0.1' }
  let(:args_default) {{
    '-input-raw'          => 'localhost:7999',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{
      :staging_host => staging_host,
      :staging_ip => staging_ip,
    }}

    it { should contain_host(staging_host).with_ensure('absent') }
    it {
      should contain_class('govuk::gor').with({
        :enable => false,
      })
    }
  end

  context '#enable_staging' do
    let(:params) {{
      :enable_staging => true,
      :staging_host => staging_host,
      :staging_ip => staging_ip,
    }}

    it { should contain_host(staging_host).with_ensure('present') }

    it {
      should contain_class('govuk::gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-http' => ["https://#{staging_host}"],
        }),
      )
    }
  end
end
