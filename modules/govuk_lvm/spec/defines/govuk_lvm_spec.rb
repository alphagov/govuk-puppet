require_relative '../../../../spec_helper'

describe 'govuk_lvm', :type => :define do
  let(:title) { 'purple' }

  context 'with no params' do
    it { expect { is_expected.to contain_lvm__volume('purple') }.to raise_error(Puppet::Error, /Must pass pv/) }
  end

  context 'required params' do
    let(:params) {{
      :pv     => '/dev/black',
      :vg     => 'orange',
    }}

    it {
      is_expected.to contain_filesystem('/dev/orange/purple').with(
        :ensure => 'present',
        :fs_type => 'ext4',
      )
      is_expected.to contain_logical_volume('purple').with(
        :ensure => 'present',
        :volume_group => 'orange',
      )
      is_expected.to contain_volume_group('orange').with(
        :ensure => 'present',
        :physical_volumes => '/dev/black',
      )
      is_expected.to contain_physical_volume('/dev/black').with(
        :ensure => 'present',
      )
    }
  end

  context 'required params with multiple physical volumes' do
    let(:params) {{
      :pv     => ['/dev/black','/dev/blue'],
      :vg     => 'orange',
    }}

    it {
      is_expected.to contain_filesystem('/dev/orange/purple').with(
        :ensure => 'present',
        :fs_type => 'ext4',
      )
      is_expected.to contain_logical_volume('purple').with(
        :ensure => 'present',
        :volume_group => 'orange',
      )
      is_expected.to contain_volume_group('orange').with(
        :ensure => 'present',
        :physical_volumes => ['/dev/black','/dev/blue'],
      )
      is_expected.to contain_physical_volume('/dev/black').with(
        :ensure => 'present',
      )
      is_expected.to contain_physical_volume('/dev/blue').with(
        :ensure => 'present',
      )
    }
  end

  context 'no_op => true' do
    let(:params) {{
      :pv    => '/dev/black',
      :vg    => 'orange',
    }}
    let(:hiera_data) {{
      :'govuk_mount::no_op' => true,
    }}

    it { is_expected.not_to contain_ext4mount('purple') }
  end

  context 'custom params' do
    let(:params) {{
      :ensure => 'absent',
      :pv     => '/dev/black',
      :vg     => 'orange',
      :fstype => 'zfs',
    }}

    it {
      is_expected.to contain_filesystem('/dev/orange/purple').with(
        :ensure => 'absent',
        :fs_type => 'zfs',
      )
      is_expected.to contain_logical_volume('purple').with(
        :ensure => 'absent',
        :volume_group => 'orange',
      )
      is_expected.to contain_volume_group('orange').with(
        :ensure => 'absent',
        :physical_volumes => '/dev/black',
      )
      is_expected.to contain_physical_volume('/dev/black').with(
        :ensure => 'absent',
      )
    }
  end
end
