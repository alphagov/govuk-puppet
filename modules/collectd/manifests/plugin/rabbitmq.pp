class collectd::plugin::rabbitmq (
  $monitoring_password,
  ){
  include collectd::plugin::python

  @file { '/usr/lib/collectd/python/rabbitmq.py':
    ensure => present,
    source => 'puppet:///modules/collectd/usr/lib/collectd/python/rabbitmq.py',
    tag    => 'collectd::plugin',
    notify => File['/etc/collectd/conf.d/rabbitmq.conf'],
  }

  @file { '/usr/lib/collectd/python/rabbitmq.pyc':
    ensure => undef,
    tag    => 'collectd::plugin',
  }

  @collectd::plugin { 'rabbitmq':
    content => template('collectd/etc/collectd/conf.d/rabbitmq.conf.erb'),
    require => Class['collectd::plugin::python'],
  }
}
