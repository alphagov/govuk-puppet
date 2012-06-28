require_relative '../../../../spec_helper'

describe 'nagios::check', :type => :define do
  let(:title) { 'heartbeat' }
  let(:pre_condition) {  'nagios::host{"bruce-forsyth":}' }
  let(:params) {{ "check_command" => "nice-to-see-you", "host_name" => "bruce-forsyth", "service_description" => "to see you nice" }}
  it { should contain_file('/etc/nagios3/conf.d/nagios_host_bruce-forsyth/heartbeat.cfg') }
end
