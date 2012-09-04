require_relative '../../spec_helper'

["staging", "preview"].each { |environment|

  describe "places_base::mongo_server", :type => :class do
    let(:facts) { { :govuk_class => "places-api", :govuk_platform => environment } }
    it do
      should create_package("mongodb-10gen")
      should_not raise_error(Puppet::ParseError)
    end
  end

}
