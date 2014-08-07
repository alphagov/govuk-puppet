require_relative '../../../../spec_helper'

describe 'router::nginx', :type => :class do
  let(:routes_path) { '/etc/nginx/router_include.conf' }
  let(:hiera_data) {{
      'app_domain' => 'giraffe.biz',
    }}

  context 'vhost_protected' do
    context 'set to false' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { should_not contain_file(routes_path).with_content(/^\s*auth_basic\s+/) }
    end

    context 'set to true' do
      let(:params) {{
        :vhost_protected => true,
      }}

      it { should contain_file(routes_path).with_content(/^\s*auth_basic\s+/) }
    end
  end

  context 'real_ip_header' do
    context 'default UNSET' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { should_not contain_file(routes_path).with_content(/^\s*real_ip_header/) }
    end

    context 'set to X-Some-Address-Header' do
      let(:params) {{
        :vhost_protected => false,
        :real_ip_header  => 'X-Some-Address-Header',
      }}

      it { should contain_file(routes_path).with_content(/^real_ip_header X-Some-Address-Header;$/) }
    end
  end

  describe 'rate_limit_tokens' do
    context '[] (default)' do
      let(:params) {{
        :vhost_protected => false,
      }}

      it { should contain_nginx__conf('rate-limiting').with_content(/
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

      it { should contain_nginx__conf('rate-limiting').with_content(/
  default \$binary_remote_addr;
  7D76CF45-12CA-4BD8-934C-F871BD3A3A9C "";
  5FD47B19-13FF-4D54-9981-A55960FDC911 "";
  7E2B0D04-0E9E-4EA0-8D72-1A72CCCC6D79 "";
}
/
      )}
    end
  end
end
