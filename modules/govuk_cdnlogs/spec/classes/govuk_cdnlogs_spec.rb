require_relative '../../../../spec_helper'

describe 'govuk_cdnlogs', :type => :class do
  let(:default_params) {{
    :log_dir          => '/tmp/logs',
    :server_key       => 'my key',
    :server_crt       => 'my crt',
    :service_port_map => { 'elephant' => 123 },
  }}

  let(:facts) {{
    :ipaddress_eth0 => '10.10.10.10',
  }}


  context 'all params' do
    let(:params) { default_params }

    describe 'server_key' do
      it { is_expected.to contain_file('/etc/ssl/rsyslog.key').with_content('my key') }
    end

    describe 'server_crt' do
      it { is_expected.to contain_file('/etc/ssl/rsyslog.crt').with_content('my crt') }
    end

    describe 'log_dir' do
      it { is_expected.to contain_file('/etc/logrotate.d/cdnlogs')
            .with_content(%r{^/tmp/logs/cdn-elephant\.log$}) }
    end
  end

  describe 'service_port_map' do
    let(:pre_condition) { <<-EOS
      Ufw::Allow <||>
      EOS
    }

    context 'empty service_port_map' do
      let(:params) { default_params.merge({
        :service_port_map => {},
      })}

      it { is_expected.not_to contain_ufw__allow('rsyslog-cdn-logs') }
      it { is_expected.to contain_rsyslog__snippet('ccc-cdnlogs').without_content(/InputTCPServerRun/) }
      it { is_expected.to contain_file('/etc/logrotate.d/cdnlogs').without_content(/rotate/) }
    end

    context 'two entries in service_port_map and log_dir' do
      let(:params) { default_params.merge({
        :service_port_map => {
          'elephant' => 123,
          'giraffe'  => 456,
        },
      })}

      it 'should open two firewall ports' do
        is_expected.to contain_ufw__allow('rsyslog-cdn-logs').with_port('123,456')
      end

      it 'should create two rulesets, bind against ports, and use log_dir' do
        is_expected.to contain_rsyslog__snippet('ccc-cdnlogs').with_content(%r{
\$template .*

ruleset\(name="cdn-elephant"\) \{
    action\(
        type="omfile"
        file="\/tmp\/logs\/cdn-elephant.log"
        template="NoFormat"
        fileOwner="root"
        fileGroup="deploy" # Create with this group so that they can be read by apps
        fileCreateMode="0640"
        dirOwner="root"
        dirGroup="adm"
        dirCreateMode="0755"
    \)
\}
\$InputTCPServerBindRuleset cdn-elephant
\$InputTCPServerRun 123

ruleset\(name="cdn-giraffe"\) \{
    action\(
        type="omfile"
        file="\/tmp\/logs\/cdn-giraffe.log"
        template="NoFormat"
        fileOwner="root"
        fileGroup="deploy" # Create with this group so that they can be read by apps
        fileCreateMode="0640"
        dirOwner="root"
        dirGroup="adm"
        dirCreateMode="0755"
    \)
\}
\$InputTCPServerBindRuleset cdn-giraffe
\$InputTCPServerRun 456

# Switch back to default ruleset
})
      end

      it 'should rotate both logs in the daily conf file' do
        is_expected.to contain_file('/etc/logrotate.d/cdnlogs')
          .with_content(%r{^/tmp/logs/cdn-elephant\.log$})
          .with_content(%r{^/tmp/logs/cdn-giraffe\.log$})
      end
      it 'should rotate daily' do
        is_expected.to contain_file('/etc/logrotate.d/cdnlogs')
          .with_content(/rotate 30$/)
      end
      it { is_expected.to contain_file('/etc/logrotate.cdn_logs_hourly.conf')
            .without_content(/rotate/) }

      context 'the elephant logs should be rotated hourly' do
        before { params[:rotate_logs_hourly] = ['elephant'] }

        it 'should rotate only giraffe logs in the daily conf file' do
          is_expected.to contain_file('/etc/logrotate.d/cdnlogs')
            .with_content(%r{^/tmp/logs/cdn-giraffe\.log$})
            .without_content(/elephant/)
        end

        it 'should rotate the elephant logs hourly' do
          is_expected.to contain_file('/etc/logrotate.cdn_logs_hourly.conf')
            .with_content(%r{^/tmp/logs/cdn-elephant\.log$})
            .with_content(/rotate 720/)
        end
      end
    end
  end
end
