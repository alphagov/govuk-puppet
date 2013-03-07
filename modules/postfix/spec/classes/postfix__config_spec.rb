require_relative '../../../../spec_helper'

describe 'postfix::config', :type => :class do
  let(:main_cf)     { '/etc/postfix/main.cf' }
  let(:sasl_passwd) { '/etc/postfix/sasl_passwd' }

  # This essentially mocks the defaults of the parent class.
  let(:default_params) {{
    :smarthost          => '',
    :smarthost_user     => '',
    :smarthost_pass     => '',
  }}

  describe 'when default params, no smarthosting' do
    let(:params) { default_params }

    it { should contain_file(main_cf).with_content(/^relayhost = $/) }
    it { should_not contain_file(main_cf).with_content(/^smtp_generic_maps/) }
    it { should_not contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
  end

  describe 'when smarthosting' do
    describe 'without auth' do
      let(:params) { default_params.merge({
        :smarthost => 'mx.example.com:587',
      })}

      it { should contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { should contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { should_not contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
      it { should_not contain_file(sasl_passwd) }
    end

    describe 'with auth' do
      let(:params) { default_params.merge({
        :smarthost      => 'mx.example.com:587',
        :smarthost_user => 'USER',
        :smarthost_pass => 'PASS',
      })}

      it { should contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { should contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { should contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
      it { should contain_file(sasl_passwd).with_content("mx.example.com:587 USER:PASS\n") }
    end

    describe 'with auth and smarthost array' do
      let(:params) { default_params.merge({
        :smarthost          => ['mx.example.com:587', 'mx1.example.com:587', 'mx2.example.com:587'],
        :smarthost_user     => 'USER',
        :smarthost_pass     => 'PASS',
      })}

      it { should contain_file(main_cf).with_content(/^relayhost = mx\.example\.com:587$/) }
      it { should contain_file(main_cf).with_content(/^smtp_generic_maps/) }
      it { should contain_file(main_cf).with_content(/^smtp_sasl_auth_enable/) }
      it { should contain_file(sasl_passwd).with_content(<<EOS
mx.example.com:587 USER:PASS
mx1.example.com:587 USER:PASS
mx2.example.com:587 USER:PASS
EOS
      )}
    end
  end
end
