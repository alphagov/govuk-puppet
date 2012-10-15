require_relative '../../../../spec_helper'

describe 'mirror', :type => :class do
  it do
    should contain_file('/usr/local/bin/govuk_mirrorer')
    should_not raise_error(Puppet::ParseError)
  end
end
