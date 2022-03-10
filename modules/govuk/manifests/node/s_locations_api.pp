# == Class: govuk::node::locations_api
#
# Locations API machine definition. Locations API machines are used for running
# the locations API and locations service applications and workers.
#
class govuk::node::s_locations_api inherits govuk::node::s_base {
  include ::govuk_rbenv::all

  limits::limits { 'root_nofile':
    ensure     => present,
    user       => 'root',
    limit_type => 'nofile',
    both       => 16384,
  }

  limits::limits { 'root_nproc':
    ensure     => present,
    user       => 'root',
    limit_type => 'nproc',
    both       => 1024,
  }

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
