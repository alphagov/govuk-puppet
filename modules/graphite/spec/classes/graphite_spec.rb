require_relative '../../../../spec_helper'

describe 'graphite', :type => :class do
  let(:facts) {{ :lsbdistcodename => 'precise' }}

  it do
    should contain_package("python-graphite").with_ensure(/precise/)
    should contain_package("python-carbon").with_ensure(/precise/)
    should contain_package("python-whisper").with_ensure(/precise/)
    should contain_service("carbon_cache")
    should contain_service("graphite")
  end
end
