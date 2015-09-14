require_relative '../../../../spec_helper'

describe 'postfix::service', :type => :class do
  it { is_expected.to contain_service('postfix').with({
    'ensure'   => 'running',
  })}
end
