require_relative '../../../../spec_helper'

describe 'puppet::master::package', :type => :class do
  let (:hiera_data) {{
    :app_domain => 'giraffe.example.com',
  }}
  let(:params) {{
    :puppetdb_version => '2.3.4',
  }}

  it { should contain_package('unicorn') }
  it { should contain_package('puppetdb-terminus').with_ensure('2.3.4') }

  it { should contain_file('/var/log/puppetmaster').with_ensure('directory') }
  it { should contain_file('/var/run/puppetmaster').with_ensure('directory') }
  it { should contain_file('/var/lib/puppet/log').with_ensure('directory') }
end

