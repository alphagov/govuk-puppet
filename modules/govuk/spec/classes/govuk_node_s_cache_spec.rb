require_relative '../../../../spec_helper'

describe 'govuk::node::s_cache', :type => :class do
  let(:node) { 'cache-1.router.somethingsomething' }
  let(:pre_condition) { '$concat_basedir = "/tmp"' }
  let(:hiera_data) {
    {
      "hosts::production::management::hosts" => {
        "cache-1" => {
          "ip" => "10.1.0.2",
        }
      },
      "govuk::apps::router::mongodb_nodes" => ['localhost'],
      "govuk::apps::authenticating_proxy::mongodb_nodes" => ['localhost'],
    }
  }
  let(:facts) { { :memtotalmb => 3953 } }

  context 'by default' do
    it 'sets the varnish upstream port to the router' do
      should contain_file('/etc/varnish/default.vcl').
        with_content(%r(.port = "3054";))
    end

    it 'configures varnish to strip cookies' do
      should contain_file('/etc/varnish/default.vcl').
        with_content(%r(unset req.http.Cookie;))
    end
  end

  context 'with authenticating_proxy enabled' do
    let(:params) { { enable_authenticating_proxy: true } }

    it 'sets the varnish upstream port to the authenticating_proxy' do
      should contain_file('/etc/varnish/default.vcl').
        with_content(%r(.port = "3107";))
    end

    it 'configures varnish to NOT strip cookies' do
      should contain_file('/etc/varnish/default.vcl').
        without_content(%r(unset req.http.Cookie;))
    end
  end
end
