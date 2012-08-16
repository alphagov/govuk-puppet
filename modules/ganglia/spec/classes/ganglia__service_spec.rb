require_relative '../../../../spec_helper'

describe 'ganglia::service', :type => :class do
  it { should contain_service('gmetad').with({
    'ensure'   => 'running',
    'provider' => 'upstart',
  })}
end
