require_relative '../../../../spec_helper'

describe 'puppet', :type => :class do
  it { should create_package("puppet").with_ensure('3.7.3').with_provider('gem') }
end
