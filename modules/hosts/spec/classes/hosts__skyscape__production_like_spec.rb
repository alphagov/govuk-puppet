require_relative '../../../../spec_helper'

describe 'hosts::skyscape::production_like', :type => :class do
  it do
    should_not raise_error(Puppet::ParseError)
  end
end
