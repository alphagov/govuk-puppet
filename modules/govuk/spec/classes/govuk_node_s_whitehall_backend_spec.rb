require_relative '../../../../spec_helper'

describe 'govuk::node::s_whitehall_backend', :type => :class do
  let(:node) { 'whitehall-backend-1.backend.somethingsomething' }
  let(:hiera_data) {{
    'app_domain'            => 'giraffe.biz',
    'asset_root'            => 'https://static.test.gov.uk',
    'website_root'          => 'www.giraffe.biz',
  }}
  context 'sync_mirror is true' do
    let(:params) {{ :sync_mirror => true }}
    it { should contain_file('/var/lib/govuk_mirror').with(
      :ensure  => 'directory',
      :owner   => 'deploy',
      :group   => 'deploy',
      :mode    => '0770',
    )}
    it { should contain_file('/var/lib/govuk_mirror/current').with(
      :ensure  => 'directory',
      :owner   => 'deploy',
      :group   => 'deploy',
      :mode    => '0770'
    ).that_requires('File[/var/lib/govuk_mirror]') }
  end

  context 'defaults' do
    let(:params) {{ }}
    it { should_not contain_file('/var/lib/govuk_mirror') }
    it { should_not contain_file('/var/lib/govuk_mirror/current') }
  end
end
