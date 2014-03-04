class collectd::plugin::redis_queues(
  $queues,
  $host = 'localhost',
  $port = 6379,
) {
  validate_array($queues)

  include collectd::plugin::python

  # Adapted from https://github.com/powdahound/redis-collectd-plugin
  file { '/usr/lib/collectd/python/redis_queues.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/lib/collectd/python/redis_queues.py',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/redis_queues.conf'],
  }

  collectd::plugin { 'redis_queues':
    content => template('collectd/etc/collectd/conf.d/redis_queues.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
