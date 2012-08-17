require_relative '../../../../spec_helper'

describe 'puppetdb::config', :type => :class do
  # on sky, bump -Xmx to 1024m
  let (:facts) {{
    :govuk_provider => 'sky'
  }}
  it { should contain_file('/etc/default/puppetdb').with_content(/^\s*JAVA_ARGS=".*-Xmx1024m.*"$/) }
end

describe 'puppetdb::config', :type => :class do
  # with no govuk_provider fact, default to 192m
  it { should contain_file('/etc/default/puppetdb').with_content(/^\s*JAVA_ARGS=".*-Xmx192m.*"$/) }
end
