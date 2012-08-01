require_relative '../../spec_helper'

["staging", "preview"].each { |environment|

  describe "ertp_base::mongo_server", :type => :class do
    let(:facts) { { :govuk_class => "ertp-mongo", :govuk_platform => environment } }
    it { should create_package("mongodb-10gen") }
    it { should_not raise_error(Puppet::ParseError) }
  end
}
