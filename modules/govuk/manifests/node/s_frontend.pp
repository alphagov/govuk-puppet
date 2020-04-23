# == Class: govuk::node::s_frontend
#
# Frontend machine definition. Frontend machines run applications
# which serve web pages to users.
#
class govuk::node::s_frontend inherits govuk::node::s_base {

  include govuk::node::s_app_server

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  include ::collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }

  govuk_envvar {
    'UNICORN_TIMEOUT': value => 15;
  }
}
