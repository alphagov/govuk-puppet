require_relative '../../spec_helper'

["production", "preview"].each { |environment|

  describe 'govuk_base::redirect_server', :type => :class do
    let(:facts) { { :govuk_class => "redirect", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::db_server', :type => :class do
    let(:facts) { { :govuk_class => "data", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::mongo_server', :type => :class do
    let(:facts) { { :govuk_class => "mongo", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::ruby_app_server::backend_server', :type => :class do
    let(:facts) { { :govuk_class => "backend", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::ruby_app_server::frontend_server', :type => :class do
    let(:facts) { { :govuk_class => "frontend", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::ruby_app_server::whitehall_frontend_server', :type => :class do
    let(:facts) { { :govuk_class => "whitehall-frontend", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::cache_server', :type => :class do
    let(:facts) { { :govuk_class => "cache", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::support_server', :type => :class do
    let(:facts) { { :govuk_class => "support", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::graylog_server', :type => :class do
    let(:facts) { { :govuk_class => "graylog", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::monitoring_server', :type => :class do
    let(:facts) { { :govuk_class => "monitoring", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

  describe 'govuk_base::management_server', :type => :class do
    let(:facts) { { :govuk_class => "management", :govuk_platform => environment } }
    it { should_not raise_error(Puppet::ParseError) }
  end

}
