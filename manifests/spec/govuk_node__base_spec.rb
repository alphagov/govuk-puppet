require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_node::base', :type => :class do
    let(:facts) { { :govuk_class => 'test', :govuk_platform => environment } }
    it { should include_class('puppet') }
    it { should include_class('puppet::cronjob') }
    it { should include_class('cron') }
    it { should include_class('govuk::deploy') }
  end

}
