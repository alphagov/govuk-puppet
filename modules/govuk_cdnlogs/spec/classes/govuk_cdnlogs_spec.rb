require_relative '../../../../spec_helper'

describe 'govuk_cdnlogs', :type => :class do
  context 'all params' do
    let(:params) {{
      :log_dir          => '/tmp/logs',
      :server_key       => 'my key',
      :server_crt       => 'my crt',
      :service_port_map => { 'elephant' => 123 },
    }}

    describe 'server_key' do
      it { should contain_file('/etc/ssl/rsyslog.key').with_content('my key') }
    end

    describe 'server_crt' do
      it { should contain_file('/etc/ssl/rsyslog.crt').with_content('my crt') }
    end

    describe 'log_dir' do
      it { should contain_file('/etc/logrotate.d/cdnlogs')
                  .with_content(/^\/tmp\/logs\/cdn-elephant\.log$/) }
    end
  end

  describe 'service_port_map' do
    let(:pre_condition) { <<-EOS
      Ufw::Allow <||>
      EOS
    }

    context 'empty service_port_map' do
      let(:params) {{
        :log_dir          => '/tmp/logs',
        :server_key       => 'key',
        :server_crt       => 'crt',
        :service_port_map => {},
      }}

      it { should_not contain_ufw__allow('rsyslog-cdn-logs') }
      it { should contain_rsyslog__snippet('ccc-cdnlogs').without_content(/InputTCPServerRun/) }
      it { should contain_file('/etc/logrotate.d/cdnlogs').without_content(/rotate/) }
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

      it 'should open two firewall ports' do
        should contain_ufw__allow('rsyslog-cdn-logs').with_port('123,456')
      end

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

      it 'should rotate both logs in the daily conf file' do
        should contain_file('/etc/logrotate.d/cdnlogs').with_content(
          /^\/tmp\/logs\/cdn-elephant\.log \/tmp\/logs\/cdn-giraffe\.log$/
        )
      end
      it 'should rotate daily' do
        should contain_file('/etc/logrotate.d/cdnlogs').with_content(
          /rotate 365$/
        )
      end

      context 'the elephant logs should be rotated hourly' do
        before { params[:rotate_logs_hourly] = ['elephant'] }

        it 'should rotate only giraffe logs in the daily conf file' do
          should contain_file('/etc/logrotate.d/cdnlogs').with_content(
            /^\/tmp\/logs\/cdn-giraffe\.log$/
          ).without_content(
            /elephant/
          )
        end
      end
    end
  end
end
