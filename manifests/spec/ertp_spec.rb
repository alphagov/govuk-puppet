require_relative '../../spec_helper'

["staging", "preview"].each { |environment|

  describe "ertp_base::mongo_server", :type => :class do
    let(:facts) { { :govuk_class => "ertp-mongo", :govuk_platform => environment } }
    it { should create_package("mongodb-10gen") }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'ertp_base::frontend_server', :type => :class do
    let(:facts) { { :govuk_class => "ertp-frontend", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'ertp_base::api_server::all', :type => :class do
    let(:facts) { { :govuk_class => "ertp-api", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  # Commented out due to failure and death: someone ERTP-y should fix this

  describe 'ertp_base::api_server::ero', :type => :class do
    let(:facts) { { :govuk_class => "ertp-api-ero", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
   end
   
  describe 'ertp_base::api_server::citizen', :type => :class do
    let(:facts) { { :govuk_class => "ertp-api-citizen", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'ertp_base::api_server::all', :type => :class do
    let(:facts) { { :govuk_class => "ertp-api", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

}

describe 'ertp_base::development', :type => :class do
  let(:facts) { { :govuk_class => "ertp-development", :govuk_platform => "development" } }
  it { should_not raise_error(Puppet::ParseError) }
end
