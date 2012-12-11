require_relative '../../../../spec_helper'

describe 'hosts::development', :type => :class do
  it do
    should_not raise_error(Puppet::ParseError)
  end
end
