require_relative '../../../../spec_helper'

describe 'icinga::check_feature', :type => :define do
  let(:title) { 'check_test_feature' }
  let(:pre_condition) {  'icinga::host{"test_host.blah.blah":}' }
  let(:facts) {{
    "hostname"   => "test_host",
    "fqdn"       => "test_host.blah.blah",
    "ipaddress"  => '10.10.10.10',
    "fqdn_short" => 'fakehost-1.management',
  }}
  let(:params) {{
    "feature"   => "test_feature"
  }}
  it {
    is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_test_host.blah.blah/'\
      'check_feature_test_feature_urgent_checker.cfg')
    is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_test_host.blah.blah/'\
      'check_feature_test_feature_high_checker.cfg')
    is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_test_host.blah.blah/'\
      'check_feature_test_feature_normal_checker.cfg')
    is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_test_host.blah.blah/'\
      'check_feature_test_feature_low_checker.cfg')
  }
end
