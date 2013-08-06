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
