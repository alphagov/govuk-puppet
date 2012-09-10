require_relative '../../../../spec_helper'

describe 'puppetdb', :type => :class do
  # on sky, bump -Xmx to 1024m
  let (:facts) {{ :govuk_provider => 'sky' }}
  it { should contain_file('/etc/init/puppetdb.conf').with_content(/-Xmx1024m/) }
end

describe 'puppetdb::config', :type => :class do
  # with no govuk_provider fact, default to 192m
  it { should contain_file('/etc/init/puppetdb.conf').with_content(/-Xmx192m/) }
end
