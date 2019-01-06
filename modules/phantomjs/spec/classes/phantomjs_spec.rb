require_relative '../../../../spec_helper'

describe 'phantomjs', :type => :class do
  let(:facts) do
    {
      :operatingsystem => 'Linux',
    }
  end

  it { is_expected.to compile }

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class('phantomjs') }
end
