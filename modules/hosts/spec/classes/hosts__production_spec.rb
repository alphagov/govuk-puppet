require_relative '../../../../spec_helper'

describe 'hosts::production', :type => :class do
  it do
    should_not raise_error(Puppet::ParseError)
  end
end
