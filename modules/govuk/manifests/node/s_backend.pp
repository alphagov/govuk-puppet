# == Class: govuk::node::s_backend
#
# Backend machine definition. Backend machines are used for running
# publishing, administration and management applications.
#
# === Parameters
#
# [*apps*]
#   An array of which applications should be running on the machine.
#
class govuk::node::s_backend (
  $apps = [],
) inherits govuk::node::s_base {
  validate_array($apps)

  include govuk::node::s_ruby_app_server

  harden::limit { 'root-nofile':
    domain => 'root',
    type   => '-', # set both hard and soft limits
    item   => 'nofile',
    value  => '16384',
  }

  harden::limit { 'root-nproc':
    domain => 'root',
    type   => '-', # set both hard and soft limits
    item   => 'nproc',
    value  => '1024',
  }

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  $app_domain = hiera('app_domain')

  include $apps

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  include govuk_elasticsearch::local_proxy

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
