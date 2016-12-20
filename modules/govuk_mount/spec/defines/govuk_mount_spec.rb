require_relative '../../../../spec_helper'

# FIXME: We're unable to test the Nagios exported resources.
describe 'govuk_mount', :type => :define do
  let(:title) { '/mnt/gruffalo' }

  context 'no_op => true' do
    let(:hiera_config) { File.expand_path('../../fixtures/hiera/hiera.yaml', __FILE__) }
    it { is_expected.not_to contain_ext4mount('/mnt/gruffalo') }
  end

  context 'custom params' do
    let(:title) { 'gruffalo' }
    let(:pre_condition) { 'govuk_lvm{"elephant": pv => "/dev/africa", vg => "serengeti"}' }
    let(:params) {{
      :disk         => '/dev/mouse',
      :mountoptions => 'snake=1',
      :mountpoint   => '/mnt/cave',
      :govuk_lvm    => 'elephant',
    }}

    it { is_expected.to contain_govuk_lvm('elephant').that_comes_before('Ext4mount[gruffalo]') }

    it { is_expected.to contain_tune_ext('/dev/mouse').that_requires('Ext4mount[gruffalo]') }

    it {
      is_expected.to contain_ext4mount('gruffalo').with(
        :disk         => '/dev/mouse',
        :mountoptions => 'snake=1',
        :mountpoint   => '/mnt/cave',
      )
    }

  end
end
