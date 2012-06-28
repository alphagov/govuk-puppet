require_relative '../../../../spec_helper'

describe 'varnish', :type => :class do
  it { should contain_file('/etc/varnish/default.vcl') }
  it { should contain_file('/etc/default/varnish') }
  it { should contain_package('varnish').with_ensure('installed') }
  it { should contain_service('varnish') }
end

