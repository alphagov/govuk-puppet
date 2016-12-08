require_relative '../../../../spec_helper'
require_relative '../../files/usr/local/bin/check_icinga'
require 'webmock/rspec'

describe CheckIcinga do
  describe 'request' do
    let(:net_http) do
      double(Net::HTTP)
    end

    let(:net_http_response) do
      double(Net::HTTP, :code => "200", :body => "")
    end

    it 'returns the response body' do
      stub_request(:get, "http://thing.com/").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '{"icinga": "working"}', :headers => {})

      expect(CheckIcinga.request('http://thing.com/')).to eq('{"icinga": "working"}')
    end

    it 'raises an error for a non-200 status code' do
      stub_request(:get, "https://example.com/").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 500, :headers => {})

      expect{ CheckIcinga.request('https://example.com/') }.to \
        raise_error(IcingaError, /Non-200 HTTP response received. Got: 500/)
    end

    it 'does not verify the TLS certficate when using TLS' do
      stub_request(:get, "https://example.com:443/").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})

      allow(Net::HTTP).to receive(:new).and_return(net_http)
      allow(net_http).to receive(:start).and_return(net_http_response)
      expect(net_http).to receive(:use_ssl=).with(true)
      expect(net_http).to receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)

      CheckIcinga.request('https://example.com/')
    end
  end

  describe 'parse_for_alerts!' do
    let(:json_body_no_worrying_alerts) do
<<EOF
{
  "status": {
    "host_status": [],
    "service_status": [
      { "host_name": "planet.earth.milky-way", "host_display_name": "planet.earth", "service_description": "the planet is on fire", "service_display_name": "the planet is burning", "status": "UNKNOWN", "state_type": "HARD", "status_information": "UNKNOWN: INTERNAL ERROR: RuntimeError: no data returned for target"}
    ]
  }
}
EOF
    end

    let(:json_body_service_critical_hard) do
<<EOF
{
  "status": {
    "host_status": [],
    "service_status": [
      { "host_name": "planet.earth.milky-way", "host_display_name": "planet.earth", "service_description": "the planet is on fire", "service_display_name": "the planet is burning", "status": "CRITICAL", "state_type": "HARD", "status_information": "CRITICAL: The planet is on fire!!11!"}
    ]
  }
}
EOF
    end

    let(:json_body_service_reboot_needed) do
<<EOF
{
  "status": {
    "host_status": [],
    "service_status": [
      { "host_name": "planet.earth.milky-way", "host_display_name": "planet.earth", "service_description": "#{CheckIcinga::REBOOT_REQUIRED_SERVICE_DESCRIPTION}", "service_display_name": "#{CheckIcinga::REBOOT_REQUIRED_SERVICE_DESCRIPTION}", "status": "WARNING", "state_type": "HARD", "status_information": "WARNING: Packages requiring reboot outstanding for longer than 0 days:"}
    ]
  }
}
EOF
    end

    let(:json_body_host_critical_soft) do
<<EOF
{
  "status": {
    "host_status": [
      { "host_name": "planet.earth.milky-way", "host_display_name": "planet.earth", "status": "DOWN", "attempts": "1/10", "state_type": "SOFT", "in_scheduled_downtime": false, "has_been_acknowledged": false, "status_information": "CRITICAL - Host Unreachable"}
    ],
    "service_status": []
  }
}
EOF
    end

    let(:json_body_host_critical_hard) do
<<EOF
{
  "status": {
    "host_status": [
      { "host_name": "planet.earth.milky-way", "host_display_name": "planet.earth", "status": "DOWN", "attempts": "1/10", "state_type": "HARD", "in_scheduled_downtime": false, "has_been_acknowledged": false, "status_information": "CRITICAL - Host Unreachable"}
    ],
    "service_status": []
  }
}
EOF
    end

    context 'when parsing JSON' do
      it 'should be able to successfully parse JSON output' do
        expect{ CheckIcinga.parse_for_alerts!(json_body_no_worrying_alerts) }.not_to raise_error
      end

      it 'responds with an error if JSON parsing unsuccessful' do
        expect{ CheckIcinga.parse_for_alerts!('NO VALID JSON FOR YOU') }.to \
          raise_error(JSON::ParserError)
      end
    end

    context 'when something is alerting' do
      it 'raises an exception for a hard critical service alert' do
        @original_stderr = $stderr
        $stderr.reopen(File.new(File::NULL, 'w'))
        expect{ CheckIcinga.parse_for_alerts!(json_body_service_critical_hard) }.to raise_error(IcingaError, /1 service alerts found/)
        $stderr = @original_stderr
      end

      it 'raises an exception for a soft critical host alert' do
        expect{ CheckIcinga.parse_for_alerts!(json_body_host_critical_soft) }.to raise_error(IcingaError, /1 host alerts found/)
      end

      it "ignores 'reboot required by apt' alerts" do

        expect { CheckIcinga.parse_for_alerts!(json_body_service_reboot_needed) }.not_to raise_error
      end
    end
  end
end
