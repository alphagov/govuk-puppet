# == Class: collectd::server::config
#
# Sets up configuration for a collectd server.
#
class collectd::server::config inherits collectd::config {
  File['/etc/collectd/conf.d/network.conf'] {
    content => template('collectd/etc/collectd/conf.d/network.conf.server.erb'),
  }

  file { '/etc/collectd/conf.d/graphite.conf':
    ensure => present,
    source => 'puppet:///modules/collectd/etc/collectd/conf.d/graphite.conf',
  }
}
