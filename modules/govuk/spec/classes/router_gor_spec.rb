require_relative '../../../../spec_helper'

describe 'router::gor', :type => :class do
  let(:host_staging) { 'www-origin-staging.production.alphagov.co.uk' }
  let(:args_default) {{
    '-input-raw'          => 'localhost:7999',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it { should contain_host(host_staging).with_ensure('absent') }
    it {
      should contain_class('govuk::gor').with({
        :enable => false,
      })
    }
  end

  context '#enable_staging' do
    let(:params) {{
      :enable_staging => true,
    }}

    it { should contain_host(host_staging).with_ensure('present') }

    it {
      should contain_class('govuk::gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-http' => ["https://#{host_staging}"],
        }),
      )
    }
  end
end
