require_relative '../../../../spec_helper'

describe 'govuk::safe_to_reboot', :type => :class do
    context '#yes' do
      let(:params) {{ }}

      it { should contain_class('govuk::safe_to_reboot::yes').with_reason('Not flagged specifically so assuming safe to reboot') }
    end

    context '#no with blank reason' do
      let(:params) {{
        :can_reboot => 'no',
        :reason => ''
      }}

      it 'should fail to compile' do
        expect { should }.to raise_error(Puppet::Error, /Machine is flagged as unsafe to reboot, but no reason supplied/)
      end
    end

    context '#careful with valid reason' do
      let(:params) {{
        :can_reboot => 'careful',
        :reason     => 'bad things will happen'
      }}

      it { should contain_class('govuk::safe_to_reboot::careful').with_reason('bad things will happen') }
    end

    context '#invalid flag' do
      let(:params) {{
        :can_reboot => 'never',
        :reason     => 'bad things will happen'
      }}
      it 'should fail to compile' do
        expect { should }.to raise_error(Puppet::Error, /Invalid value for govuk::safe_to_reboot::can_reboot: never/)
      end
    end
end
