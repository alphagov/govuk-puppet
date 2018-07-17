require_relative '../../../../spec_helper'

describe 'puppet::puppetserver::package', :type => :class do
  it { is_expected.to contain_package('puppetserver') }
end

