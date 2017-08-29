# == Class: govuk::node::s_backend
#
# Backend machine definition. Backend machines are used for running
# publishing, administration and management applications.
#
class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_app_server

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

  package { 'graphviz':
    ensure => installed,
  }

  include imagemagick

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  if ! $::aws_migration {
    include govuk_elasticsearch::local_proxy
  }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
