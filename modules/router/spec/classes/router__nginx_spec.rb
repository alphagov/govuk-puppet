require_relative '../../../../spec_helper'

describe 'router::nginx', :type => :class do
  let(:assets_config) { '/etc/nginx/sites-available/assets-origin.environment.example.com' }
  let(:router_config) { '/etc/nginx/router_include.conf' }

  context 'app_specific_static_asset_routes' do
    context 'default UNSET' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { is_expected.not_to contain_file(router_config).with_content(%r{^\s*location \/assets\/frontend\s+}) }
    end

    context 'set for a host' do
      let(:params) {{
        :vhost_protected => false,
        :app_specific_static_asset_routes => { "/assets/frontend" => "frontend" },
      }}

      it { is_expected.to contain_file(router_config).with_content(%r{^\s*location /assets/frontend\s+}) }
    end
  end

  context 'vhost_protected' do
    context 'set to false' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { is_expected.not_to contain_file(router_config).with_content(/^\s*auth_basic\s+/) }
    end

    context 'set to true' do
      let(:params) {{
        :vhost_protected => true,
      }}

      it { is_expected.to contain_file(router_config).with_content(/^\s*auth_basic\s+/) }
    end
  end

  context 'real_ip_header' do
    context 'default UNSET' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { is_expected.not_to contain_file(assets_config).with_content(/^\s*real_ip_header/) }
      it { is_expected.not_to contain_file(router_config).with_content(/^\s*real_ip_header/) }
    end

    context 'set to X-Some-Address-Header' do
      let(:params) {{
        :vhost_protected => false,
        :real_ip_header  => 'X-Some-Address-Header',
      }}

      it { is_expected.to contain_file(assets_config).with_content(/^\s*real_ip_header X-Some-Address-Header;$/) }
      it { is_expected.to contain_file(router_config).with_content(/^\s*real_ip_header X-Some-Address-Header;$/) }
    end
  end

  describe 'rate_limit_tokens' do
    context '[] (default)' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { is_expected.to contain_nginx__conf('rate-limiting').with_content(/
  default \$binary_remote_addr;
}
/
      )}
    end

    context 'array of strings' do
      let(:params) {{
        :vhost_protected   => false,
        :rate_limit_tokens => %w{
          7D76CF45-12CA-4BD8-934C-F871BD3A3A9C
          5FD47B19-13FF-4D54-9981-A55960FDC911
          7E2B0D04-0E9E-4EA0-8D72-1A72CCCC6D79
        },
      }}

      it { is_expected.to contain_nginx__conf('rate-limiting').with_content(/
  default \$binary_remote_addr;
  7D76CF45-12CA-4BD8-934C-F871BD3A3A9C "";
  5FD47B19-13FF-4D54-9981-A55960FDC911 "";
  7E2B0D04-0E9E-4EA0-8D72-1A72CCCC6D79 "";
}
/
      )}
    end
  end

  describe 'page_ttl_404' do
    context 'default' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { is_expected.to contain_file(router_config).with_content(/add_header Cache-Control "public, max-age=30" always;/) }
    end

    context 'a different number' do
      let(:params) {{
        :page_ttl_404  => '668',
        :vhost_protected => false,
      }}

      it { is_expected.to contain_file(router_config).with_content(/add_header Cache-Control "public, max-age=668" always;/) }
    end
  end
end
