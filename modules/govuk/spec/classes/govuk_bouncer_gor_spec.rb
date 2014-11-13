require_relative '../../../../spec_helper'

describe 'bouncer::gor', :type => :class do
  let(:staging_ip) { '127.0.0.1' }
  let(:args_default) {{
    '-input-raw'          => ':80',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it {
      should contain_class('govuk::gor').with({
        :enable => false,
      })
    }
  end

  context '#enable_staging' do
    let(:params) {{
      :enable_staging => true,
      :staging_ip => staging_ip,
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-http' => ["http://#{staging_ip}"],
        }),
      )
    }
  end

  context 'enabled but no staging IP is invalid' do
    let(:params) {{
      :enable_staging => true,
      :staging_ip => 'not.an.ip.address',
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => false,
      )
    }
  end

  context 'enabled but no staging IP specified' do
    let(:params) {{
      :enable_staging => true,
    }}

    it {
      should contain_class('govuk::gor').with(
        :enable => false,
      )
    }
  end
end
