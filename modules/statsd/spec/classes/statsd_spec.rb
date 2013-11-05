require_relative '../../../../spec_helper'

describe 'statsd', :type => :class do
  context "graphite_hostname => graphite.example.com" do
    let(:params) {{
      :graphite_hostname => 'graphite.example.com',
    }}

    it { should contain_class('nodejs') }
    it { should contain_package('statsd') }
    it { should contain_file('/etc/init/statsd.conf') }
    it { should contain_service('statsd') }

    it { should contain_file('/etc/statsd.conf').with_content(/ graphiteHost: "graphite.example.com"$/) }
  end
end
