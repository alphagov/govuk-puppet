require_relative '../../../../spec_helper'

describe 'postfix::service', :type => :class do
  it { should contain_service('postfix').with({
    'ensure'   => 'running',
  })}
end
