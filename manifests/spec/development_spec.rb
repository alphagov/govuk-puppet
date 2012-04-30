require_relative '../../spec_helper'

describe 'development', :type => :class do
  let(:facts) { { :govuk_class => "development" } }
  it { should create_package("apache2") }
  it { should_not raise_error(Puppet::ParseError) }
end
