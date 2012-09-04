require_relative '../../spec_helper'

describe 'govuk_node::backend_server', :type => :class do
  context 'in preview' do
    let(:facts) { { :govuk_class => "backend", :govuk_platform => 'preview' } }
    it do
      should_not raise_error(Puppet::ParseError)
      should include_class('govuk::apps::panopticon')
      should_not contain_apache2__vhost__passenger('panopticon.preview.alphagov.co.uk')
    end
  end

  # Don't want to deploy unicorn panopticon at the moment, need to
  # give notice to content editors re downtime
  # -- ppotter, 2012-09-03
  context 'in production' do
    let(:facts) { { :govuk_class => "backend", :govuk_platform => 'production' } }
    it do
      should_not raise_error(Puppet::ParseError)
      should include_class('govuk::apps::panopticon')
      should_not contain_apache2__vhost__passenger('panopticon.production.alphagov.co.uk')
    end
  end
end
