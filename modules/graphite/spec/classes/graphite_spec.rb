require_relative '../../../../spec_helper'

describe 'graphite', :type => :class do
  it { should contain_package("python-graphite-web").with_ensure('present') }
  it { should contain_package("python-carbon").with_ensure('present') }
  it { should contain_package("python-whisper").with_ensure('present') }
end