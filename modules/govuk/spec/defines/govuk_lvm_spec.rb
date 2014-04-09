require_relative '../../../../spec_helper'

describe 'govuk::lvm', :type => :define do
  let(:title) { 'purple' }

  context 'with no params' do
    it { expect { should contain_lvm__volume('purple') }.to raise_error(Puppet::Error, /Must pass pv/) }
  end

  context 'required params' do
    let(:params) {{
      :pv     => '/dev/black',
      :vg     => 'orange',
    }}

    it {
      should contain_filesystem('/dev/orange/purple').with(
        :ensure => 'present',
        :fs_type => 'ext4',
      )
      should contain_logical_volume('purple').with(
        :ensure => 'present',
        :volume_group => 'orange',
      )
      should contain_volume_group('orange').with(
        :ensure => 'present',
        :physical_volumes => '/dev/black',
      )
      should contain_physical_volume('/dev/black').with(
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
      :'govuk::mount::no_op' => true,
    }}

    it { should_not contain_ext4mount('purple') }
  end

  context 'custom params' do
    let(:params) {{
      :ensure => 'absent',
      :pv     => '/dev/black',
      :vg     => 'orange',
      :fstype => 'zfs',
    }}

    it {
      should contain_filesystem('/dev/orange/purple').with(
        :ensure => 'absent',
        :fs_type => 'zfs',
      )
      should contain_logical_volume('purple').with(
        :ensure => 'absent',
        :volume_group => 'orange',
      )
      should contain_volume_group('orange').with(
        :ensure => 'absent',
        :physical_volumes => '/dev/black',
      )
      should contain_physical_volume('/dev/black').with(
        :ensure => 'absent',
      )
    }
  end
end
