require_relative '../../../../spec_helper'

describe 'loadbalancer::balance', :type => :define do
  let (:hiera_data) {{
      'app_domain' => 'test.gov.uk',
    }}

  context 'external load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :servers => ['giraffe-1', 'giraffe-2', 'giraffe-3'],
      }
    }

    it 'should create nginx config for loadbalancing' do
      should contain_nginx__config__site('giraffe.test.gov.uk')
        .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
        .with_content(/listen\s+443 ssl/)
      should_not contain_nginx__config__site('giraffe.test.gov.uk').with_content(/deny all/)
      should_not contain_nginx__config__site('giraffe.test.gov.uk').with_content(/listen\s+80/)
    end
  end

  context 'single load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :servers => 'giraffe-1',
      }
    }

    it 'should create nginx config for loadbalancing' do
      should contain_nginx__config__site('giraffe.test.gov.uk')
        .with_content(/server giraffe-1:443/)
    end
  end

  context 'internal load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :internal_only => true,
        :servers => ['giraffe-1', 'giraffe-2', 'giraffe-3'],
      }
    }

    it 'should create nginx config for loadbalancing' do
      should contain_nginx__config__site('giraffe.test.gov.uk')
        .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
        .with_content(/listen\s+443 ssl/)
        .with_content(/deny all/)
    end
  end

  context 'https_only load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :https_only => false,
        :servers => ['giraffe-1', 'giraffe-2', 'giraffe-3'],
      }
    }

    it 'should create nginx config for loadbalancing' do
      should contain_nginx__config__site('giraffe.test.gov.uk')
        .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
        .with_content(/listen\s+80/)
        .with_content(/listen\s+443 ssl/)
    end
  end
end
