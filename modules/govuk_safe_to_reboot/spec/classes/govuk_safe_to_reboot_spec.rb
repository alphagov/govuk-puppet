require_relative '../../../../spec_helper'

describe 'govuk_safe_to_reboot', :type => :class do
    context '#yes' do
      let(:params) {{ }}

      it { is_expected.to contain_class('govuk_safe_to_reboot::yes').with_reason('Not flagged specifically so assuming safe to reboot') }
    end

    context '#no with blank reason' do
      let(:params) {{
        :can_reboot => 'no',
        :reason => ''
      }}

      it 'should fail to compile' do
        is_expected.to raise_error(Puppet::Error, /Machine is flagged as unsafe to reboot, but no reason supplied/)
      end
    end

    context '#careful with valid reason' do
      let(:params) {{
        :can_reboot => 'careful',
        :reason     => 'bad things will happen'
      }}

      it { is_expected.to contain_class('govuk_safe_to_reboot::careful').with_reason('bad things will happen') }
    end

    context '#invalid flag' do
      let(:params) {{
        :can_reboot => 'never',
        :reason     => 'bad things will happen'
      }}
      it 'should fail to compile' do
        is_expected.to raise_error(Puppet::Error, /Invalid value for govuk_safe_to_reboot::can_reboot: never/)
      end
    end
end
