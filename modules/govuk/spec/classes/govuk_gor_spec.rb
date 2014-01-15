require_relative '../../../../spec_helper'

describe 'govuk::gor', :type => :class do
  let(:host_staging) { 'www-origin-staging.production.alphagov.co.uk' }
  let(:host_plat1prod) { 'www-origin-plat1.production.alphagov.co.uk' }

  context 'default (disabled)' do
    let(:params) {{ }}

    it { should contain_host(host_staging).with_ensure('absent') }
    it { should contain_host(host_plat1prod).with_ensure('absent') }
  end

  context '#enable_staging' do
    let(:params) {{
      :enable_staging => true,
    }}

    it { should contain_host(host_staging).with_ensure('present') }
    it { should contain_host(host_plat1prod).with_ensure('present') }
  end

  context '#enable_plat1prod' do
    let(:params) {{
      :enable_plat1prod => true,
    }}

    it { should contain_host(host_staging).with_ensure('present') }
    it { should contain_host(host_plat1prod).with_ensure('present') }
  end

  context '#enable_staging and #enable_plat1prod' do
    let(:params) {{
      :enable_staging   => true,
      :enable_plat1prod => true,
    }}

    it { should contain_host(host_staging).with_ensure('present') }
    it { should contain_host(host_plat1prod).with_ensure('present') }
  end
end
