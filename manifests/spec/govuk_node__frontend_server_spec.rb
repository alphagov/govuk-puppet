require_relative '../../spec_helper'

describe 'govuk_node::frontend_server', :type => :class do
  context 'in preview' do
    let(:facts) { { :govuk_class => "frontend", :govuk_platform => 'preview' } }
    it { should_not raise_error(Puppet::ParseError) }
    it { should include_class('govuk::apps::frontend') }
    it { should include_class('govuk::apps::search') }
    it { should_not contain_apache2__vhost__passenger('www.preview.alphagov.co.uk') }
    it { should_not contain_apache2__vhost__passenger('search.preview.alphagov.co.uk') }
  end

  # Don't want to deploy unicorn frontend at the moment, still testing
  # -- ppotter, 2012-09-03
  context 'in production' do
    let(:facts) { { :govuk_class => "frontend", :govuk_platform => 'production' } }
    it { should_not raise_error(Puppet::ParseError) }
    it { should_not include_class('govuk::apps::frontend') }
    it { should_not include_class('govuk::apps::search') }
    it { should contain_apache2__vhost__passenger('www.production.alphagov.co.uk') }
    it { should contain_apache2__vhost__passenger('search.production.alphagov.co.uk') }
  end
end
