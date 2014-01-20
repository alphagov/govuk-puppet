require_relative '../../../../spec_helper'

describe 'govuk::lvm', :type => :define do
    let(:title) { 'purple' }
  context 'with no params' do

    context 'environment fox' do
      let(:facts) {{
        :environment => 'fox',
      }}

      it do
        expect {
        should contain_lvm__volume('purple')
      }.to raise_error(Puppet::Error, /Must pass pv/)
      end
    end
  end

  context 'required params' do

    let(:params) {{
      :pv     => '/dev/black',
      :vg     => 'orange',
    }}

    it {
      should contain_lvm__volume('purple').with(
        :ensure => 'present',
        :pv     => '/dev/black',
        :vg     => 'orange',
        :fstype => 'ext4',
      )
    }
    %w{vagrant}.each do |environment|
      context "environment #{environment}" do
        let(:facts) {{
          :environment => environment,
        }}

        it { should_not contain_ext4mount('purple') }
      end
    end
  end
  context 'custom params' do
    let(:params) {{
      :ensure => 'absent',
      :pv     => '/dev/black',
      :vg     => 'orange',
      :fstype => 'zfs',
    }}

    it {
      should contain_lvm__volume('purple').with(
        :ensure => 'absent',
        :pv     => '/dev/black',
        :vg     => 'orange',
        :fstype => 'zfs',
      )
    }
  end
end
