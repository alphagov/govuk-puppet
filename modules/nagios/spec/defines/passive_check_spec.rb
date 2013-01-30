require_relative '../../../../spec_helper'

# nagios::passive_check should create file in correct place using host_name param
describe 'nagios::passive_check', :type => :define do
  let(:title) { 'heartbeat' }
  let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
  let(:params) {{
    "host_name" => "bruce-forsyth",
    "service_description" => "to see you nice"
  }}
  it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/heartbeat.cfg') }
end

# nagios::passive_check should create file using right template (we'll check for some known content)
describe 'nagios::passive_check', :type => :define do
  let(:title) { 'heartbeat' }
  let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
  let(:params) {{
    "host_name" => "bruce-forsyth",
    "service_description" => "to see you nice"
  }}
  it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/heartbeat.cfg').
       with_content(/check_command\s+check_dummy!1!"Unexpected active check on passive service/)
     }
end

