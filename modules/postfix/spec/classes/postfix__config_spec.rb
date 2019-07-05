require_relative '../../../../spec_helper'

describe 'postfix::config', :type => :class do
  let(:pre_condition) { 'package { "postfix": }' }
  let(:mailname)    { '/etc/mailname' }
  let(:main_cf)     { '/etc/postfix/main.cf' }
  let(:sasl_passwd) { '/etc/postfix/sasl_passwd' }

  let(:facts) {{
    :fqdn     => 'host.example.com',
    :domain   => 'example.com',
    :hostname => 'host',
  }}
  # This mocks the defaults of the parent class.
  let(:default_params) {{
    :smarthost           => :undef,
    :smarthost_user      => :undef,
    :smarthost_pass      => :undef,
    :rewrite_mail_domain => 'localhost',
    :rewrite_mail_list   => 'noemail'
  }}

  describe 'when default params, no smarthosting' do
    let(:params) { default_params }

    it { is_expected.to contain_file(main_cf).with_content(/^relayhost = $/) }
    it { is_expected.to contain_file(main_cf).without_content(/^smtp_generic_maps/) }
    it { is_expected.to contain_file(main_cf).without_content(/^smtp_sasl_auth_enable/) }

    it { is_expected.to contain_file(mailname).with_content("host.example.com\n") }
    it { is_expected.to contain_file(main_cf).with_content(/^myhostname = host\.example\.com$/) }
    it { is_expected.to contain_file(main_cf).with_content(/^mydestination = host\.example\.com, localhost\.example\.com, , localhost$/) }
  end

  describe 'when smarthosting' do
    describe 'without auth' do
      let(:params) { default_params.merge({
        :smarthost => 'mx.example.com:587',
      })}

      it { is_expected.to contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { is_expected.to contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { is_expected.to contain_file(main_cf).without_content(/^smtp_sasl_auth_enable/) }
      it { is_expected.not_to contain_file(sasl_passwd) }
    end

    describe 'with auth' do
      let(:params) { default_params.merge({
        :smarthost      => 'mx.example.com:587',
        :smarthost_user => 'USER',
        :smarthost_pass => 'PASS',
      })}

      it { is_expected.to contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { is_expected.to contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { is_expected.to contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
      it { is_expected.to contain_file(sasl_passwd).with_content("mx.example.com:587 USER:PASS\n") }
    end

    describe 'with auth and smarthost array' do
      let(:params) { default_params.merge({
        :smarthost          => ['mx.example.com:587', 'mx1.example.com:587', 'mx2.example.com:587'],
        :smarthost_user     => 'USER',
        :smarthost_pass     => 'PASS',
      })}

      it { is_expected.to contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { is_expected.to contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { is_expected.to contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
      it { is_expected.to contain_file(sasl_passwd).with_content(<<EOS
mx.example.com:587 USER:PASS
mx1.example.com:587 USER:PASS
mx2.example.com:587 USER:PASS
EOS
      )}
    end
  end
end
