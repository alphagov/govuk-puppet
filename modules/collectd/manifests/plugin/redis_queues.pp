# == Class: collectd::plugin::redis_queues
#
# Sets up a collectd plugin to monitor Redis queues.
#
# === Parameters
#
# [*queues*]
#   An array of queues to monitor.
#
# [*host*]
#   The host that Redis runs on.
#
# [*port*]
#   The port that Redis responds on.
#
class collectd::plugin::redis_queues(
  $queues,
  $host = 'localhost',
  $port = 6379,
) {
  validate_array($queues)

  include collectd::plugin::python

  # Adapted from https://github.com/powdahound/redis-collectd-plugin
  file { '/usr/lib/collectd/python/redis_queues.py':
    ensure => present,
    source => 'puppet:///modules/collectd/usr/lib/collectd/python/redis_queues.py',
    tag    => 'collectd::plugin',
    notify => File['/etc/collectd/conf.d/redis_queues.conf'],
  }

  collectd::plugin { 'redis_queues':
    content => template('collectd/etc/collectd/conf.d/redis_queues.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
