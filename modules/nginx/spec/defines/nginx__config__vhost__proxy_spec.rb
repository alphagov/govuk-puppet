require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::proxy', :type => :define do
  let(:title) { 'rabbit' }

  context 'with a list of upstreams' do
    let(:params) {{
      :to => ['a.internal', 'b.internal', 'c.internal'],
    }}

    it 'should install a proxy vhost' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/server a\.internal;/)
        .with_content(/server b\.internal;/)
        .with_content(/server c\.internal;/)
    end

    it 'should try some options before falling through to the default' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/try_files \$uri\/index.html \$uri.html \$uri @app;/)
    end

    it { is_expected.to contain_nginx__config__site('rabbit')
      .with_content(/^\s+proxy_pass http:\/\/rabbit-proxy;$/) }

  end

  context 'with @single_page_app set' do
    let(:params) {{
      :to              => ['a.internal'],
      :single_page_app => "/example-path"
    }}

    it 'should only proxy to the single_page_app path' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/try_files \$uri\/index.html \$uri.html \$uri \/example-path;/)
    end
  end

  context 'with @read_timeout set' do
    let(:params) {{
      :to           => ['a.internal'],
      :read_timeout => '60',
    }}

    it 'should set the proxies read_timeout to value' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/proxy_read_timeout 60;/)
    end
  end

  context 'if in aws' do
    let(:title) { 'rabbit' }

    let(:params) {{
      :to => ['a.internal'],
    }}

    let(:facts) {{
     :aws_migration => true,
    }}

    it 'should add a wildcard match' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/server_name rabbit rabbit.*/)
    end
  end

  context 'if in aws and passed an alias' do
    let(:title) { 'rabbit' }

    let(:params) {{
      :to      => ['a.internal'],
      :aliases => ['cat'],
    }}

    let(:facts) {{
     :aws_migration => true,
    }}

    it 'should add a wildcard match, and add the alias along with an alias wildcard match' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/server_name rabbit rabbit.* cat cat.*/)
    end
  end

  context 'if in aws' do
    let(:title) { 'rabbit' }

    let(:params) {{
      :to            => ['a.internal'],
    }}

    let(:facts) {{
     :aws_migration => true,
    }}

    it 'should add original lb headers' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/proxy_set_header GOVUK-Request-Id \$govuk_request_id;/)
    end
  end

  context 'if in aws and deny_crawlers set to true' do
    let(:title) { 'rabbit' }

    let(:params) {{
      :to            => ['a.internal'],
      :deny_crawlers => true,
    }}

    let(:facts) {{
     :aws_migration => true,
    }}

    it 'should add location robots.txt' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/location = \/robots.txt/)
    end
  end
  
  context 'with to_ssl true' do
    let(:params) {{
      :to     => ['a.internal', 'b.internal', 'c.internal'],
      :to_ssl => true,
    }}

    it 'should install a proxy vhost' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/server a\.internal:443;/)
        .with_content(/server b\.internal:443;/)
        .with_content(/server c\.internal:443;/)
    end

    it { is_expected.to contain_nginx__config__site('rabbit')
      .with_content(/^\s+proxy_pass https:\/\/rabbit-proxy;$/) }

  end

  context 'with frame_options set to "deny"' do
    let(:params) do
      {
        :to => ['a.internal'],
        :frame_options => 'deny',
      }
    end

    it 'should add the X-Frame-Options header with the DENY value' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/add_header X-Frame-Options DENY/)
    end
  end

  context 'with frame_options set to "sameorigin"' do
    let(:params) do
      {
        :to => ['a.internal'],
        :frame_options => 'sameorigin',
      }
    end

    it 'should add the X-Frame-Options header with the SAMEORIGIN value' do
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(/add_header X-Frame-Options SAMEORIGIN/)
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
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(%r"location /secret {\s+return 404;\s+}")
      is_expected.to contain_nginx__config__site('rabbit')
        .with_content(%r"location /supersecret {\s+return 404;\s+}")
    end
  end

  context 'with ssl_certtype wildcard_publishing' do
    let(:params) do
      {
        :to => ['a.internal'],
      }
    end

    it {
      is_expected.to contain_nginx__config__ssl('rabbit').with_certtype('wildcard_publishing')
    }
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
        is_expected.to contain_nginx__config__site('rabbit')
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
          is_expected.to contain_nginx__config__site('rabbit')
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
          is_expected.to contain_nginx__config__site('rabbit')
        }.to raise_error(Puppet::Error, /Invalid ensure value/)
      end
    end
  end

end
