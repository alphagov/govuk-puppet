require_relative '../../../../spec_helper'

describe 'nagios::check_feature', :type => :define do
  let(:title) { 'check_test_feature' }
  let(:pre_condition) {  'nagios::host{"test_class-test_host":}' }
  let(:facts) {{
    "govuk_class" => "test_class",
    "hostname"    => "test_host"
  }}
  let(:params) {{
    "feature"   => "test_feature"
  }}
  it {
    should contain_file('/etc/nagios3/conf.d/nagios_host_test_class-test_host/'\
      'check_feature_test_feature_high_checker.cfg')
    should contain_file('/etc/nagios3/conf.d/nagios_host_test_class-test_host/'\
      'check_feature_test_feature_medium_checker.cfg')
    should contain_file('/etc/nagios3/conf.d/nagios_host_test_class-test_host/'\
      'check_feature_test_feature_low_checker.cfg')
  }
end
