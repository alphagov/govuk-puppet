require_relative '../../../../spec_helper'

describe 'akamai::event_data', :type => :class do
  context 'when enabled' do
    [true, 'true'].each do |enable_val|
      context "with value #{enable_val.inspect}" do
        let(:params) {{ :enable => enable_val }}

        it { should contain_file('/usr/local/akamai').with_ensure('directory') }
        it { should contain_file('/usr/local/akamai/akamai_logs.yaml').with_ensure('present') }
        it { should contain_file('/usr/local/akamai/pull_akamai_event_data.py').with_ensure('present') }
        it { should contain_cron('pull_akamai_event_data').with_ensure('present') }
      end
    end
  end

  context 'when disabled' do
    [false, 'false'].each do |enable_val|
      context "with value #{enable_val.inspect}" do
        let(:params) {{ :enable => enable_val }}

        it { should contain_file('/usr/local/akamai').with_ensure(nil) }
        it { should contain_file('/usr/local/akamai/akamai_logs.yaml').with_ensure('absent') }
        it { should contain_file('/usr/local/akamai/pull_akamai_event_data.py').with_ensure('absent') }
        it { should contain_cron('pull_akamai_event_data').with_ensure('absent') }
      end
    end
  end
end
