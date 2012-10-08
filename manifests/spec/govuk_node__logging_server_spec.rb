require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_node::logging_server', :type => :class do
    let(:facts) { { :govuk_class => "logging", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

}
