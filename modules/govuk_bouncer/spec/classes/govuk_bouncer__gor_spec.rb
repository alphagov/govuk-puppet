require_relative '../../../../spec_helper'

describe 'govuk_bouncer::gor', :type => :class do
  let(:ip_address) { '127.0.0.1' }
  let(:args_default) {{
    '-input-raw'          => ':80',
    '-http-allow-method' => %w{GET HEAD OPTIONS},
    '-http-original-host' => '',
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it {
      is_expected.to contain_class('govuk_gor').with({
        :enable => false,
      })
    }
  end

  context '#enabled' do
    let(:params) {{
      :enabled => true,
      :ip_address => ip_address,
    }}

    it {
      is_expected.to contain_class('govuk_gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-http' => ["http://#{ip_address}"],
        }),
        :envvars => {
          'GODEBUG' => 'netdns=go',
        }
      )
    }
  end

  context 'enabled but no staging IP is invalid' do
    let(:params) {{
      :enabled => true,
      :ip_address => 'not.an.ip.address',
    }}

    it {
      is_expected.to contain_class('govuk_gor').with(
        :enable => false,
      )
    }
  end

  context 'enabled but no staging IP specified' do
    let(:params) {{
      :enabled => true,
    }}

    it {
      is_expected.to contain_class('govuk_gor').with(
        :enable => false,
      )
    }
  end
end
