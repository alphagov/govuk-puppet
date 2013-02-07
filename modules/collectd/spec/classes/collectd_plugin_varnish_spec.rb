require_relative '../../../../spec_helper'

describe 'collectd::plugin::varnish', :type => :class do
  # We can't test the virtual resource so we have to check for the presence
  # or absence of the warning message in the form of a Notify[].
  let(:warning_string) { 
    'collectd::plugin::varnish not supported on Lucid. Omitting plugin'
  }

  context 'Ubuntu Lucid' do
    let(:facts) {{ :lsbdistcodename => 'lucid' }}
    it { should contain_notify(warning_string) }
  end

  context 'Ubuntu Precise' do
    let(:facts) {{ :lsbdistcodename => 'precise' }}
    it { should_not contain_notify(warning_string) }
  end
end
