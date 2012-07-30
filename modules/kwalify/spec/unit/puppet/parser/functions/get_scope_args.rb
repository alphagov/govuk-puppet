#!/usr/bin/env rspec

require 'spec_helper'

describe "the get_scope_args function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  let(:scope) { Puppet::Parser::Scope.new }
  let(:ast) { Puppet::Parser::AST }

  it "should exist" do
    Puppet::Parser::Functions.function("get_scope_args").should ==
      "function_get_scope_args"
  end

  it "should raise a ParseError if there is any arguments" do
    expect {
      scope.function_get_scope_args(['a'])
    }.should( raise_error(Puppet::ParseError))
  end

  pending "should return a list of arguments when used inside a class" do
    # Here we look out for the function and make sure it returns the
    # correct values
  end

end
