require_relative '../../../../spec_helper'

describe 'statsd', :type => :class do
  context "graphite_hostname => graphite.example.com" do
    let(:params) {{
      :graphite_hostname => 'graphite.example.com',
    }}

    it { is_expected.to contain_package('statsd') }
    it { is_expected.to contain_service('statsd') }

    it { is_expected.to contain_file('/etc/statsd/config.js').with_content(/ graphiteHost: "graphite.example.com"$/) }
  end
end
