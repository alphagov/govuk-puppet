require_relative '../../../../spec_helper'

describe 'router::nginx', :type => :class do
  let(:routes_path) { '/etc/nginx/router_routes.conf' }

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
end
