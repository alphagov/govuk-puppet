require_relative '../../../../spec_helper'

describe 'govuk_cdnlogs', :type => :class do
  context 'all params' do
    let(:params) {{
      :log_dir          => '/tmp/logs',
      :server_key       => 'my key',
      :server_crt       => 'my crt',
      :service_port_map => {},
    }}

    describe 'server_key' do
      it { should contain_file('/etc/ssl/rsyslog.key').with_content('my key') }
    end

    describe 'server_crt' do
      it { should contain_file('/etc/ssl/rsyslog.crt').with_content('my crt') }
    end

    describe 'log_dir' do
      it { should contain_file('/etc/logrotate.d/cdnlogs').with_content(/^\/tmp\/logs\/\*\.log$/) }
    end
  end

  describe 'service_port_map' do
    context 'empty service_port_map' do
      let(:params) {{
        :log_dir          => '/tmp/logs',
        :server_key       => 'key',
        :server_crt       => 'crt',
        :service_port_map => {},
      }}

      it { should contain_rsyslog__snippet('ccc-cdnlogs').without_content(/InputTCPServerRun/) }
    end

    context 'two entries in service_port_map and log_dir' do
      let(:params) {{
        :log_dir          => '/tmp/logs',
        :server_key       => '',
        :server_crt       => '',
        :service_port_map => {
          'elephant' => 123,
          'giraffe'  => 456,
        },
      }}

      it 'should create two rulesets, bind against ports, and use log_dir' do
        should contain_rsyslog__snippet('ccc-cdnlogs').with_content(/
\$template .*

\$RuleSet cdn-elephant
\*\.\* -\/tmp\/logs\/cdn-elephant\.log;NoFormat
\$InputTCPServerBindRuleset cdn-elephant
\$InputTCPServerRun 123

\$RuleSet cdn-giraffe
\*\.\* -\/tmp\/logs\/cdn-giraffe\.log;NoFormat
\$InputTCPServerBindRuleset cdn-giraffe
\$InputTCPServerRun 456

# Switch back to default ruleset
/)
      end
    end
  end
end
