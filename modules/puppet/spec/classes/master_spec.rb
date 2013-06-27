require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  it { should contain_class('puppetdb') }
  it { should contain_class('puppet::master::package') }
  it { should contain_class('puppet::master::config') }
  it { should contain_class('puppet::master::generate_cert') }
  it { should contain_class('puppet::master::firewall') }
  it { should contain_class('puppet::master::service') }
  it { should contain_class('puppet::master::nginx') }
end
