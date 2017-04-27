require_relative '../../../../spec_helper'

describe 'collectd::package', :type => :class do
  it { is_expected.to contain_package('collectd-core').with_ensure('5.4.0-3ubuntu2') }

  it { is_expected.to contain_package('libyajl2') }

end
