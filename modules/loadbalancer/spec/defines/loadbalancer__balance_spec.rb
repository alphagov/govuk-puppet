require_relative '../../../../spec_helper'

describe 'loadbalancer::balance', :type => :define do
  let(:default_params) {{
    :servers => ['server-1'],
  }}

  context 'external load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :servers => ['giraffe-1', 'giraffe-2', 'giraffe-3'],
      }
    }

    it 'should create nginx config for loadbalancing' do
      is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
        .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
        .with_content(/listen\s+443 ssl/)
      is_expected.to contain_nginx__config__site('giraffe.environment.example.com').with_content(/listen\s+80;\n\s+rewrite/)
      is_expected.not_to contain_nginx__config__site('giraffe.environment.example.com').with_content(/deny all/)
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
      is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
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
      is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
        .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
        .with_content(/listen\s+443 ssl/)
        .with_content(/deny all/)
    end

    describe 'with a custom HTTPS port set' do
      let(:params) {
        {
          :https_port => 8443,
          :internal_only => true,
          :servers => ['giraffe-1', 'giraffe-2', 'giraffe-3'],
        }
      }

      it 'should create nginx config for loadbalancing' do
        is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
          .with_content(/server giraffe-1:443.*server giraffe-2:443.*server giraffe-3:443/m)
          .with_content(/listen\s+8443 ssl/)
      end
    end

    context 'HTTP and HTTPS behaviour' do
      describe 'error_on_http is true' do
        let(:params) { default_params.merge({
          :error_on_http => true,
        })}

        it 'should serve errors for HTTP' do
          is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
            .with_content(/listen 80;\n\s+return 426/)
        end
      end

      describe 'error_on_http is false' do
        let(:params) { default_params.merge({
          :error_on_http => false,
        })}

        it 'should redirect from HTTP to HTTPS' do
          is_expected.to contain_nginx__config__site('giraffe.environment.example.com')
            .with_content(/listen 80;\n\s+rewrite \^\/\(\.\*\) https/)
        end
      end
    end
  end
end
