require_relative '../../../../spec_helper'

describe 'haproxy::balance_ssl', :type => :define do
  context 'external load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :servers => {
          'giraffe-1' => '1.1.1.1',
          'giraffe-2' => '2.2.2.2',
          'giraffe-3' => '3.3.3.3',
        },
        :listen_port => 8080,
        :health_check_port => 9090,
      }
    }

    it 'should create haproxy fragment listening on 8080' do
      # ensure correct order
      should contain_concat__fragment('haproxy_listen_ssl_giraffe').
        with_content(/listen giraffe 0.0.0.0:8080.*server giraffe-1.*server giraffe-2.*server giraffe-3/m)
      # ensure correct config
      should contain_concat__fragment('haproxy_listen_ssl_giraffe').
        with_content(/server giraffe-1 1.1.1.1:443.*port 9090/)
    end

    it 'should create nginx proxy allowing everyone access' do
      should contain_nginx__config__ssl('giraffe.dev.gov.uk')
      should contain_nginx__config__site('ssl_giraffe.dev.gov.uk')
      should_not contain_nginx__config__site('ssl_giraffe.dev.gov.uk').with_content(/deny all/)
    end
  end

  context 'internal load balancer' do
    let(:title) { 'giraffe' }
    let(:params) {
      {
        :servers => {'giraffe-1' => '1.1.1.1'},
        :listen_port => 8080,
        :health_check_port => 9090,
        :internal_only => true,
      }
    }

    it 'should create nginx proxy only allowing local access' do
      should contain_nginx__config__ssl('giraffe.dev.gov.uk')
      should contain_nginx__config__site('ssl_giraffe.dev.gov.uk').
        with_content(/deny all/)
    end
  end
end
