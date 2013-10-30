require_relative '../../../../spec_helper'

describe 'icinga::host', :type => :define do
  let(:title) { 'bruce-forsyth' }
  let(:facts) {{
      "hostname"    => "test_host",
      "fqdn"        => "test_host.blah.blah"
  }}
  it { should contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth.cfg') }
end
