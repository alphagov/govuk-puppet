class collectd::plugin::rabbitmq {
  include collectd::plugin::python

  @file { '/usr/lib/collectd/python/rabbitmq.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/lib/collectd/python/rabbitmq.py',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/rabbitmq.conf'],
  }

  @file { '/usr/lib/collectd/python/rabbitmq.pyc':
    ensure  => undef,
    tag     => 'collectd::plugin',
  }

  @collectd::plugin { 'rabbitmq':
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/rabbitmq.conf',
    require => Class['collectd::plugin::python'],
  }
}
