require_relative '../../../../spec_helper'

# FIXME: We're unable to test the Nagios exported resources.
describe 'govuk::mount', :type => :define do
  context 'param defaults (undef)' do
    let(:title) { '/mnt/gruffalo' }
    let(:params) {{ }}

    it {
      should contain_ext4mount('/mnt/gruffalo').with(
        :disk         => nil,
        :mountoptions => nil,
        :mountpoint   => '/mnt/gruffalo',
      )
    }
  end

  context 'custom params' do
    let(:title) { 'gruffalo' }
    let(:params) {{
      :disk         => '/dev/mouse',
      :mountoptions => 'snake=1',
      :mountpoint   => '/mnt/cave',
    }}

    it {
      should contain_ext4mount('gruffalo').with(
        :disk         => '/dev/mouse',
        :mountoptions => 'snake=1',
        :mountpoint   => '/mnt/cave',
      )
    }
  end
end
