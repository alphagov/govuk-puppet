require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  # Each context is in a separate file as mandated in
  # hiera-puppet-helper's README, otherwise tests will fail
  context 'with invalid Hiera data' do

    let(:hiera_config) { File.expand_path(File.join(__FILE__, '..', '..', 'fixtures/hiera/hiera_using_common_only.yaml')) }

    # Upstream 'puppet-sudo' module should remove any invalid sudoers.d
    # entries
    it { is_expected.not_to contain_file('10_gary').with({
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
