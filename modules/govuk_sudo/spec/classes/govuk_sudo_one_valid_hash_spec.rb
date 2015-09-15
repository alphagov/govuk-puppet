require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  # Each context is in a separate file as mandated in
  # hiera-puppet-helper's README, otherwise tests will fail
  context 'with valid Hiera data from one Hiera hash' do

    let(:hiera_config) { File.expand_path(File.join(__FILE__, '..', '..', 'fixtures/hiera/hiera_using_common_only.yaml')) }

    it { is_expected.to contain_file('10_spongebob').with({
        'ensure'  => 'present',
        'content' => "spongebob ALL=(ALL) NOPASSWD:ALL\n",
        'owner'   => 'root',
        'group'   => 'root',
        'path'    => '/etc/sudoers.d/10_spongebob',
        'mode'    => '0440'
      })
    }

  end

end
