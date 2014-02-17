require_relative '../../../../spec_helper'

# FIXME: We're unable to test the Nagios exported resources.
describe 'govuk::mount', :type => :define do
  let(:title) { '/mnt/gruffalo' }

  context 'param defaults (undef)' do
    let(:params) {{ }}

    context 'environment fox' do
      it {
        should contain_ext4mount('/mnt/gruffalo').with(
          :disk         => nil,
          :mountoptions => nil,
          :mountpoint   => '/mnt/gruffalo',
        )
      }
    end
  end

  context 'no_op => true' do
    let(:params) {{
      :no_op => true,
    }}

    it { should_not contain_ext4mount('/mnt/gruffalo') }
  end

  context 'custom params' do
    let(:title) { 'gruffalo' }
    let(:pre_condition) { 'govuk::lvm{"elephant": pv => "/dev/africa", vg => "serengeti"}' }
    let(:params) {{
      :disk         => '/dev/mouse',
      :mountoptions => 'snake=1',
      :mountpoint   => '/mnt/cave',
      :govuk_lvm    => 'elephant',
    }}

    it { should contain_govuk__lvm('elephant').that_comes_before('Ext4mount[gruffalo]') }

    it {
      should contain_ext4mount('gruffalo').with(
        :disk         => '/dev/mouse',
        :mountoptions => 'snake=1',
        :mountpoint   => '/mnt/cave',
      )
    }

  end
end
