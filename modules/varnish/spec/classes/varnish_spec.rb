require_relative '../../../../spec_helper'

describe 'varnish', :type => :class do
  it { is_expected.to contain_file('/etc/varnish/default.vcl') }
  it { is_expected.to contain_file('/etc/default/varnish') }
  it { is_expected.to contain_package('varnish').with_ensure('installed') }
  it { is_expected.to contain_service('varnish') }
end
