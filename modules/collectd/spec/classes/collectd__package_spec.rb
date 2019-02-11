require_relative '../../../../spec_helper'

describe 'collectd::package', :type => :class do
  it { is_expected.to contain_package('collectd-core').with_ensure('5.8.0.145.gca1cb27-1~trusty') }

  it { is_expected.to contain_package('libyajl2') }

end
