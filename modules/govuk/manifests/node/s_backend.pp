# == Class: govuk::node::s_backend
#
# Backend machine definition. Backend machines are used for running
# publishing, administration and management applications.
#
class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_app_server

  if $::aws_environment == 'production' {
    include ::hosts::default
    include ::hosts::backend_migration
    include icinga::client::check_pings
  }

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

  package { 'redis-tools':
    ensure => installed,
  }

  include imagemagick

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }
}
