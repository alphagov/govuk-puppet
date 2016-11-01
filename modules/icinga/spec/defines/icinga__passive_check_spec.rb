require_relative '../../../../spec_helper'

# icinga::passive_check should create file in correct place using host_name param
describe 'icinga::passive_check', :type => :define do
  let(:title) { 'heartbeat' }
  let(:pre_condition) {  'icinga::host{"bruce-forsyth":}' }
  let(:params) {{
    "host_name" => "bruce-forsyth",
    "service_description" => "to see you nice"
  }}
  let(:facts) {{
    'ipaddress'  => '10.10.10.10',
    'fqdn_short' => 'fakehost-1.management',
  }}

  it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/heartbeat.cfg') }
end

# icinga::passive_check should create file using right template (we'll check for some known content)
describe 'icinga::passive_check', :type => :define do
  let(:title) { 'heartbeat' }
  let(:facts) {{
    'ipaddress' => '10.10.10.10',
    :fqdn_short => 'fakehost-1.management',
  }}
  let(:pre_condition) {  'icinga::host{"bruce-forsyth":}' }
  let(:params) {{
    "host_name" => "bruce-forsyth",
    "service_description" => "to see you nice"
  }}
  it { is_expected.to contain_file('/etc/icinga/conf.d/icinga_host_bruce-forsyth/heartbeat.cfg').
       with_content(/check_command\s+check_dummy!1!"Unexpected active check on passive service/)
     }
end

