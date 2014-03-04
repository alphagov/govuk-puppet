class collectd::plugin::redis(
  $host = 'localhost',
  $port = 6379,
) {
  include collectd::plugin::python

  # Attribution: https://github.com/powdahound/redis-collectd-plugin
  file { '/usr/lib/collectd/python/redis_info.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/lib/collectd/python/redis_info.py',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/redis.conf'],
  }

  collectd::plugin { 'redis':
    content => template('collectd/etc/collectd/conf.d/redis.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
