require_relative '../../../../spec_helper'

describe 'filebeat', :type => :class do

  it { is_expected.to compile }
  it { is_expected.to compile.with_all_deps }

  context 'collecting prospectors' do
    let(:pre_condition) { '@filebeat::prospector {"foo": }' }
    it { is_expected.to contain_filebeat__prospector('foo') }
  end
end
