require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_node::base', :type => :class do
    let(:facts) { { :govuk_class => 'test', :govuk_platform => environment } }
    it do
      should include_class('puppet')
      should include_class('puppet::cronjob')
      should include_class('cron')
      should include_class('govuk::deploy')
    end
  end

}
