require_relative '../../../../spec_helper'

describe 'govuk::node::s_cache', :type => :class do
  let(:node) { 'cache-1.router.somethingsomething' }
  let(:pre_condition) { '$concat_basedir = "/tmp"' }
  let(:facts) {{
    :memorysize_mb => 3953.43,
    :vdc           => 'fake_vdc',
  }}

  context 'by default' do
    it 'sets the varnish upstream port to the router' do
      is_expected.to contain_file('/etc/varnish/default.vcl').
        with_content(%r(.port = "3054";))
    end

    it 'configures varnish to strip cookies' do
      is_expected.to contain_file('/etc/varnish/default.vcl').
        with_content(%r(unset req.http.Cookie;))
    end
  end

  context 'with authenticating_proxy enabled' do
    let(:params) { { enable_authenticating_proxy: true } }

    it 'sets the varnish upstream port to the authenticating_proxy' do
      is_expected.to contain_file('/etc/varnish/default.vcl').
        with_content(%r(.port = "3107";))
    end

    it 'configures varnish to NOT strip cookies' do
      is_expected.to contain_file('/etc/varnish/default.vcl').
        without_content(%r(unset req.http.Cookie;))
    end
  end
end
