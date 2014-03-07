require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  # Each context is in a separate file as mandated in
  # hiera-puppet-helper's README, otherwise tests will fail
  context 'with invalid Hiera data' do

    # FIXME: Force rspec-puppet to invalidate the cached Puppet catalog
    # for this test. This prevents tests from incorrectly failing due to
    # a race condition. This can be removed once this is addressed by
    # 'hiera-puppet-helper'.
    let(:facts) {{ :cache_bust => Time.now }}

    let(:hiera_config) do
    {
      :backends => ['yaml'],
      :hierarchy => ['common'],
      :yaml => {
        :datadir => File.expand_path(File.join(__FILE__, '..', '..', 'fixtures/hiera'))
      }
    }
    end

    # Upstream 'puppet-sudo' module should remove any invalid sudoers.d
    # entries
    it { should_not contain_file('10_gary').with({
        'ensure'  => 'present',
        'content' => "gary BORKBORKBORK ALL=(ALL) NOPASSWD:ALL\n",
        'owner'   => 'root',
        'group'   => 'root',
        'path'    => '/etc/sudoers.d/10_gary',
        'mode'    => '0440'
      })
    }

  end

end
