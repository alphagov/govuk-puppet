require_relative '../../../../spec_helper'

describe 'graphite', :type => :class do
  it do
    should contain_package("python-graphite-web").with_ensure('present')
    should contain_package("python-carbon").with_ensure('present')
    should contain_package("python-whisper").with_ensure('present')
    should contain_service("carbon_cache")
    should contain_service("graphite")
  end
end
