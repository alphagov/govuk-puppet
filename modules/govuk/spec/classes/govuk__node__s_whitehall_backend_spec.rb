require_relative '../../../../spec_helper'

describe 'govuk::node::s_whitehall_backend', :type => :class do
  let(:node) { 'whitehall-backend-1.backend.somethingsomething' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat/',
    :memorysize     => '15.95 GB',
    :vdc            => 'fake_vdc',
  }}
  context 'sync_mirror is true' do
    let(:params) {{ :sync_mirror => true }}
    it { is_expected.to contain_file('/var/lib/govuk_mirror').with(
      :ensure  => 'directory',
      :owner   => 'deploy',
      :group   => 'deploy',
      :mode    => '0770',
    )}
    it { is_expected.to contain_file('/var/lib/govuk_mirror/current').with(
      :ensure  => 'directory',
      :owner   => 'deploy',
      :group   => 'deploy',
      :mode    => '0770'
    ).that_requires('File[/var/lib/govuk_mirror]') }
  end

  context 'defaults' do
    let(:params) {{ }}
    it { is_expected.not_to contain_file('/var/lib/govuk_mirror') }
    it { is_expected.not_to contain_file('/var/lib/govuk_mirror/current') }
  end
end
