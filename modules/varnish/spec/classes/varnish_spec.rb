require_relative '../../../../spec_helper'

describe 'varnish', :type => :class do
  let(:hiera_data) {{
    'app_domain' => 'giraffe.biz',
  }}
  let(:facts) {{
    :cache_bust => Time.now,
  }}

  it { should contain_file('/etc/varnish/default.vcl') }
  it { should contain_file('/etc/default/varnish') }
  it { should contain_package('varnish').with_ensure('installed') }
  it { should contain_service('varnish') }
end
