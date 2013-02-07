require_relative '../../../../spec_helper'

describe 'varnish', :type => :class do
  it do
    should contain_file('/etc/varnish/default.vcl')
    should contain_file('/etc/default/varnish')
    should contain_package('varnish').with_ensure('installed')
    should contain_service('varnish')
  end
end
