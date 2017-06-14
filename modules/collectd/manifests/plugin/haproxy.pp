# == Class: collectd::plugin::haproxy
#
# Setup a collectd plugin to monitor HAProxy.
#
# === Parameters
#
# [*proxies*]
#   The proxy to monitor. Defaults to 'server' and 'backend'
#
class collectd::plugin::haproxy(
  $proxies = ['server', 'backend'],
) {
  include collectd::plugin::python

  # Attribution: https://github.com/signalfx/collectd-haproxy
  @file { '/usr/lib/collectd/python/haproxy.py':
    ensure => present,
    source => 'puppet:///modules/collectd/usr/lib/collectd/python/haproxy.py',
    tag    => 'collectd::plugin',
    notify => File['/etc/collectd/conf.d/haproxy.conf'],
  }

  @file { '/usr/lib/collectd/python/haproxy.pyc':
    ensure => undef,
    tag    => 'collectd::plugin',
  }

  @collectd::plugin { 'haproxy':
    content => template('collectd/etc/collectd/conf.d/haproxy.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
