require_relative '../../../../spec_helper'

# FIXME: We're unable to test the Nagios exported resources.
describe 'govuk::mount', :type => :define do
  context 'param defaults (undef)' do
    let(:title) { '/mnt/gruffalo' }
    let(:params) {{ }}

    context 'environment fox' do
      let(:facts) {{
        :environment => 'fox',
      }}

      it {
        should contain_ext4mount('/mnt/gruffalo').with(
          :disk         => nil,
          :mountoptions => nil,
          :mountpoint   => '/mnt/gruffalo',
        )
      }
    end

    %w{vagrant}.each do |environment|
      context "environment #{environment}" do
        let(:facts) {{
          :environment => environment,
        }}

        it { should_not contain_ext4mount('/mnt/gruffalo') }
      end
    end
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
