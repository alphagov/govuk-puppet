require_relative '../../../../spec_helper'

describe 'elasticsearch::local_proxy', :type => :class do
  let(:vhost_name) { 'elasticsearch-local-proxy' }
  let(:default_port) { '9200' }
  let(:default_timeout) { '5' }

  context 'default params, three servers' do
    let(:params) {{
      :servers => [
        'es0.example.com',
        'es1.example.com',
        'es2.example.com',
      ]
    }}
    let(:listen_args) { "localhost:#{default_port};" }
    let(:allow_args) { '127\.0\.0\.1;$' }

    it 'should reference two upstreams with default port' do
      should contain_nginx__config__site(vhost_name).with_content(
/^upstream #{vhost_name}-upstream {
  server es0\.example\.com:#{default_port}\s[^\n]+;
  server es1\.example\.com:#{default_port}\s[^\n]+;
  server es2\.example\.com:#{default_port}\s[^\n]+;
}/
      )
    end

    it 'should default to read_timeout 5' do
      should contain_nginx__config__site(vhost_name).with_content(/^\s+proxy_read_timeout 5;$/)
    end

    it 'should default to port 9200' do
      should contain_nginx__config__site(vhost_name).with_content(/^\s+listen #{listen_args}/)
    end

    it 'should not listen on any other interfaces or ports' do
      should_not contain_nginx__config__site(vhost_name).with_content(/^\s+listen\s+(?!#{listen_args})/)
    end

    it 'should only allow connections from loopback' do
      should contain_nginx__config__site(vhost_name).with_content(
/^\s+allow #{allow_args}
\s+deny all;/
      )
    end

    it 'should not allow any other client IPs' do
      should_not contain_nginx__config__site(vhost_name).with_content(/\s+allow\s+(?!#{allow_args})/)
    end
  end

  context 'one server, port 999, read_timeout 10' do
    let(:params) {{
      :read_timeout => 10,
      :port         => 999,
      :servers      => [
        'es0.example.com',
      ]
    }}

    it 'should reference one upstream with custom port' do
      should contain_nginx__config__site(vhost_name).with_content(
/^upstream #{vhost_name}-upstream {
  server es0\.example\.com:999\s[^\n]+;
}/
      )
    end

    it 'should have proxy_read_timeout 10' do
      should contain_nginx__config__site(vhost_name).with_content(/^\s+proxy_read_timeout 10;$/)
    end

    it 'should listen on port 999' do
      should contain_nginx__config__site(vhost_name).with_content(/^\s+listen localhost:999;$/)
    end
  end
end
