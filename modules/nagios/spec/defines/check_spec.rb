require_relative '../../../../spec_helper'

# nagios::check should create file in correct place using host_name param
describe 'nagios::check', :type => :define do
  context "should create file in correct location" do
    let(:title) { 'heartbeat' }
    let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
    let(:params) {{
      "check_command" => "nice-to-see-you",
      "host_name" => "bruce-forsyth",
      "service_description" => "to see you nice"
    }}
    it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/heartbeat.cfg') }
  end

  context "should add max_check_attempts when attempts_before_hard_state passed in" do
    let(:title) { 'test_max_check_attempts' }
    let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
    let(:params) {{
      "check_command"              => "nice-to-see-you",
      "host_name"                  => "bruce-forsyth",
      "service_description"        => "to see you nice",
      "attempts_before_hard_state" => "1",
    }}
    it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/test_max_check_attempts.cfg').
         with_content(/max_check_attempts\s+1/)
    }
  end

  context "should use govuk_regular_service by default" do
    let(:title) { 'default_service' }
    let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
    let(:params) {{
      "check_command" => "nice-to-see-you",
      "host_name" => "bruce-forsyth",
      "service_description" => "has default service as regular"
    }}
    it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/default_service.cfg').
         with_content(/use\s+govuk_regular_service/)
    }
  end
end
