require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_node::management_server', :type => :class do
    let(:facts) { { :govuk_class => "management", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

}
