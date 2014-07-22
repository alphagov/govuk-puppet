require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::proxy', :type => :define do
  let(:title) { 'rabbit' }

  context 'with a list of upstreams' do
    let(:params) {{
      :to => ['a.internal', 'b.internal', 'c.internal'],
    }}

    it 'should install a proxy vhost' do
      should contain_nginx__config__site('rabbit')
        .with_content(/server a\.internal;/)
        .with_content(/server b\.internal;/)
        .with_content(/server c\.internal;/)
    end

    it { should contain_nginx__config__site('rabbit')
      .with_content(/^\s+proxy_pass http:\/\/rabbit-proxy;$/) }

  end

  context 'with to_ssl true' do
    let(:params) {{
      :to     => ['a.internal', 'b.internal', 'c.internal'],
      :to_ssl => true,
    }}

    it 'should install a proxy vhost' do
      should contain_nginx__config__site('rabbit')
        .with_content(/server a\.internal:443;/)
        .with_content(/server b\.internal:443;/)
        .with_content(/server c\.internal:443;/)
    end

    it { should contain_nginx__config__site('rabbit')
      .with_content(/^\s+proxy_pass https:\/\/rabbit-proxy;$/) }

  end

  context 'with intercept_errors true' do
    let(:params) do
      {
        :to => ['a.internal'],
        :intercept_errors => true,
      }
    end

    it 'should install simple_error_pages' do
      should contain_nginx__config__site('rabbit')
        .with_content(/include \/etc\/nginx\/simple_error_pages\.conf;/)
    end
  end

  context 'with deny_framing true' do
    let(:params) do
      {
        :to => ['a.internal'],
        :deny_framing => true,
      }
    end

    it 'should add the X-Frame-Options header' do
      should contain_nginx__config__site('rabbit')
        .with_content(/add_header X-Frame-Options/)
    end
  end

  context 'with hidden_paths' do
    let(:params) do
      {
        :to => ['a.internal'],
        :hidden_paths => ['/secret', '/supersecret'],
      }
    end

    it 'should respond with a 404 for hidden paths' do
      should contain_nginx__config__site('rabbit')
        .with_content(%r"location /secret {\s+return 404;\s+}")
      should contain_nginx__config__site('rabbit')
        .with_content(%r"location /supersecret {\s+return 404;\s+}")
    end
  end

  context 'with ensure' do
    context 'absent' do
      let(:params) do
        {
          :to => ['a.internal'],
          :ensure => 'absent',
        }
      end

      it do
        should contain_nginx__config__site('rabbit')
          .with_ensure('absent')
      end
    end

    context 'true' do
      let(:params) do
        {
          :to => ['a.internal'],
          :ensure => 'true',
        }
      end

      it do
        expect {
          should contain_nginx__config__site('rabbit')
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end

    context 'false' do
      let(:params) do
        {
          :to => ['a.internal'],
          :ensure => 'false',
        }
      end

      it do
        expect {
          should contain_nginx__config__site('rabbit')
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
  end

end
