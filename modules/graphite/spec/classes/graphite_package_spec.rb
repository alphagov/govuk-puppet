require_relative '../../../../spec_helper'

describe 'graphite::package', :type => :class do
  let(:facts) {{ :lsbdistcodename => 'precise' }}

  it { should contain_package("python-graphite").with_ensure(/precise/) }
  it { should contain_package("python-carbon").with_ensure(/precise/) }
  it { should contain_package("python-whisper").with_ensure(/precise/) }
end
