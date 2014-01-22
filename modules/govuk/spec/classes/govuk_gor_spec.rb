require_relative '../../../../spec_helper'

shared_examples 'hosts and logstream enabled' do
  it { should contain_host(host_staging).with_ensure('present') }
  it { should contain_host(host_plat1prod).with_ensure('present') }
  it { should contain_govuk__logstream('gor_upstart_log').with_enable('true') }
end

describe 'govuk::gor', :type => :class do
  let(:host_staging) { 'https://www-origin-staging.production.alphagov.co.uk' }
  let(:host_plat1prod) { 'https://www-origin-plat1.production.alphagov.co.uk' }
  let(:args_default) {{
    '-input-raw'          => 'localhost:7999',
    '-output-http-method' => %w{GET HEAD OPTIONS},
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it { should contain_host(host_staging).with_ensure('absent') }
    it { should contain_host(host_plat1prod).with_ensure('absent') }
    it { should contain_class('gor').with_service_ensure('stopped') }
    it { should contain_govuk__logstream('gor_upstart_log').with_enable('false') }
  end

  context '#enable_staging' do
    let(:params) {{
      :enable_staging => true,
    }}

    it_should_behave_like 'hosts and logstream enabled'

    it {
      should contain_class('gor').with(
        :service_ensure => 'running',
        :args           => args_default.merge({
          '-output-http' => [host_staging],
        }),
      )
    }
  end

  context '#enable_plat1prod' do
    let(:params) {{
      :enable_plat1prod => true,
    }}

    it_should_behave_like 'hosts and logstream enabled'

    it {
      should contain_class('gor').with(
        :service_ensure => 'running',
        :args           => args_default.merge({
          '-output-http' => [host_plat1prod],
        }),
      )
    }
  end

  context '#enable_staging and #enable_plat1prod' do
    let(:params) {{
      :enable_staging   => true,
      :enable_plat1prod => true,
    }}

    it_should_behave_like 'hosts and logstream enabled'

    it {
      should contain_class('gor').with(
        :service_ensure => 'running',
        :args           => args_default.merge({
          '-output-http' => [host_staging, host_plat1prod],
        }),
      )
    }
  end
end
