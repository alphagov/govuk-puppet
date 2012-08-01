require_relative '../../spec_helper'

describe 'ertp_base::development', :type => :class do
  let(:facts) { { :govuk_class => "ertp-development", :govuk_platform => "development" } }
  it { should_not raise_error(Puppet::ParseError) }
end
