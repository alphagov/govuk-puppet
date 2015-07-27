# == Class: collectd::server::config
#
# Sets up configuration for a collectd server.
#
class collectd::server::config inherits collectd::config {
  File['/etc/collectd/conf.d/network.conf'] {
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/network.conf.server',
  }

  file { '/etc/collectd/conf.d/graphite.conf':
    ensure => present,
    source => 'puppet:///modules/collectd/etc/collectd/conf.d/graphite.conf',
  }
}
