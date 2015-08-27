# == Class: collectd::plugin::tcp
#
# Setup a collectd plugin to monitor TCP metrics from /proc/net/netstat +
# /proc/net/snmp.
#
class collectd::plugin::tcp (
  $metrics = [],
  ) {
  include collectd::plugin::python

  validate_array($metrics)

  @file { '/usr/lib/collectd/python/tcp.py':
    ensure => present,
    source => 'puppet:///modules/collectd/usr/lib/collectd/python/tcp.py',
    tag    => 'collectd::plugin',
    notify => File['/etc/collectd/conf.d/tcp.conf'],
  }

  @file { '/usr/lib/collectd/python/tcp.pyc':
    ensure => undef,
    tag    => 'collectd::plugin',
  }

  @collectd::plugin { 'tcp':
    content => template('collectd/etc/collectd/conf.d/tcp.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
