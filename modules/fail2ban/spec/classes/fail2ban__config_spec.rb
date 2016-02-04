require_relative '../../../../spec_helper'

describe 'fail2ban::config', :type => :class do
  let(:facts) {{
    :lsbdistcodename => 'trusty',
  }}

  it do
    is_expected.to contain_file('/etc/fail2ban/fail2ban.local')
    is_expected.to contain_file('/etc/fail2ban/jail.local')

    is_expected.to contain_file('/etc/fail2ban/jail.local').without_content(/ignoreip/)
  end

  context "with some jail config snippets" do
    let(:pre_condition) {
      <<-EOT
      @fail2ban::config::jail_snippet { 'test':
        content => "foo",
      }
      EOT
    }

    it "should realise the jail config snippets" do
      expect(subject).to contain_file("/etc/fail2ban/jail.d/01_test.local")
        .with_content("foo")
    end

    it "should skip the snippet on precise" do
      facts[:lsbdistcodename] = "precise"

      expect(subject).not_to contain_file("/etc/fail2ban/jail.d/01_test.local")
    end
  end

  context 'with whitelist parameter' do
    allowed = ['127.0.0.1/8', '10.10.10.10', 'www.example.org']

    let (:params) {{ whitelist: allowed }}

    describe 'should contain whitelisted values' do

      it { should contain_file('/etc/fail2ban/jail.local')
             .with_content(/ignoreip = #{allowed.join(' ')}/)
         }
    end
  end
end
