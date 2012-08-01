require_relative '../../spec_helper'

["staging", "preview"].each { |environment|

  describe 'ertp_base::api_server::ero', :type => :class do
    let(:facts) { { :govuk_class => "ertp-api-ero", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
   end
}
