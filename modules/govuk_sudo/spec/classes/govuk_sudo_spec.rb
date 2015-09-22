require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  context 'under Ubuntu with no class parameters' do

    let :facts do
    {
      :osfamily => 'debian',
      :operatingsystem => 'Ubuntu',
    }
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('govuk_sudo') }
    it { is_expected.to contain_class('sudo') }
    it { is_expected.to contain_package('sudo') }

    it { is_expected.to contain_file('/etc/sudoers').with({
        'ensure' => 'present',
        'path'    => '/etc/sudoers',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0440',
        'source'  => 'puppet:///modules/govuk_sudo/sudoers'
      })
    }

  end

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

  context 'with valid Hiera data from two Hiera hashes, relying on hash merging' do
    let(:hiera_config) { File.expand_path(File.join(__FILE__, '..', '..', 'fixtures/hiera/hiera_using_two_hiera_levels.yaml')) }

    it { is_expected.to contain_file('10_spongebob').with({
        'ensure'  => 'present',
        'content' => "spongebob ALL=(ALL) NOPASSWD:ALL\n",
        'owner'   => 'root',
        'group'   => 'root',
        'path'    => '/etc/sudoers.d/10_spongebob',
        'mode'    => '0440'
      })
    }

    it { is_expected.to contain_file('10_patrick').with({
        'ensure'  => 'present',
        'content' => "patrick ALL=(ALL) NOPASSWD:ALL\n",
        'owner'   => 'root',
        'group'   => 'root',
        'path'    => '/etc/sudoers.d/10_patrick',
        'mode'    => '0440'
      })
    }
  end

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
