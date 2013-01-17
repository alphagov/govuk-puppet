require_relative '../../../../spec_helper'

describe 'puppetdb', :type => :class do
  # on sky, bump -Xmx to 1024m
  let (:facts) {{ :govuk_provider => 'sky' }}
  let (:params) {{ :package_ensure => '1.2.3' }}
  it { should contain_file('/etc/init/puppetdb.conf').with_content(/-Xmx1024m/) }
  it { should contain_package('puppetdb').with_ensure('1.2.3') }
end

describe 'puppetdb::config', :type => :class do
  # with no govuk_provider fact, default to 192m
  it { should contain_file('/etc/init/puppetdb.conf').with_content(/-Xmx192m/) }
end
