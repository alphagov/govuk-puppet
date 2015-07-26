# == Class: collectd::server
#
# Sets up a server to receive collectd metrics.
#
class collectd::server {
  include ::collectd

  class { 'collectd::server::config':
    notify  => Class['collectd::service'],
    require => Class['collectd::package'],
  }

  class { 'collectd::server::firewall':
    require => Class['collectd::server::config'],
  }
}
