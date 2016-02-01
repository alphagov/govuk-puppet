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

  class { 'govuk::apps::whitehall':
    configure_frontend     => true,
    vhost                  => 'whitehall-frontend',
    vhost_protected        => false,
    # 10GB for a warning
    nagios_memory_warning  => 10737418240,
    # 12GB for a critical
    nagios_memory_critical => 12884901888,
  }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
