# == Class: govuk::node::s_whitehall_frontend
#
# Configures a frontend server for the Whitehall application
#
class govuk::node::s_whitehall_frontend inherits govuk::node::s_base {
  include govuk::node::s_app_server
  include nginx

  $app_domain = hiera('app_domain')

  nginx::config::vhost::redirect { "whitehall.${app_domain}":
    to => "https://whitehall-frontend.${app_domain}/",
  }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
