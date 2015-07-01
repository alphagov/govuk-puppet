require_relative '../../../../spec_helper'

describe 'govuk::node::s_whitehall_backend', :type => :class do
  let(:node) { 'whitehall-backend-1.backend.somethingsomething' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat/',
    :memorysize =>  '15.95 GB',
  }}
  let(:hiera_data) {
    {
      "hosts::production::backend::hosts" => {
        "whitehall-backend-1" => {
          "ip" => "10.3.0.25",
        }
      }
    }
  }
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
