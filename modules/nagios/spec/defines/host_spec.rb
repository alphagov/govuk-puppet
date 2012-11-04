require_relative '../../../../spec_helper'

describe 'nagios::host', :type => :define do
  let(:title) { 'bruce-forsyth' }
  let(:facts) {{
      "govuk_class" => "test_class",
      "hostname"    => "test_host",
      "fqdn"        => "test_host.blah.blah"
  }}
  it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth.cfg') }
end
