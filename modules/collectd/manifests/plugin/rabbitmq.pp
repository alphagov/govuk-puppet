class collectd::plugin::rabbitmq {
  include collectd::plugin::python

  @file { '/usr/lib/collectd/python/rabbitmq_info.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/lib/collectd/python/rabbitmq_info.py',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/rabbitmq_info.conf'],
  }

  @file { '/usr/lib/collectd/python/rabbitmq_info.pyc':
    ensure  => undef,
    tag     => 'collectd::plugin',
  }

  @collectd::plugin { 'rabbitmq_info':
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/rabbitmq_info.conf',
    require => Class['collectd::plugin::python'],
  }
}
