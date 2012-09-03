require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_node::management_server_slave', :type => :class do
    let(:facts) { { :govuk_class => "management_slave", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

}
