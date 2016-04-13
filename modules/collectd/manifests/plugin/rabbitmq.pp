# == Class: collectd::plugin::rabbitmq
#
# Sets up the NYTimes collectd-rabbitmq collectd plugin to monitor RabbitMQ.
# See https://github.com/NYTimes/collectd-rabbitmq
#
# === Parameters
#
# [*monitoring_password*]
#   The password to the 'monitoring' user which can access monitoring information from RabbitMQ.
#
class collectd::plugin::rabbitmq (
  $monitoring_password,
  ){

  @package { 'collectd-rabbitmq':
    ensure   => '1.3.0',
    provider => pip,
  }

  @file { '/usr/share/collectd/types.db.rabbitmq':
    ensure  => present,
    source  => 'puppet:///modules/collectd/usr/share/collectd/types.db.rabbitmq',
    tag     => 'collectd::plugin',
    notify  => File['/etc/collectd/conf.d/rabbitmq.conf'],
    require => Package['collectd-core'],
  }

  @collectd::plugin { 'rabbitmq':
    content => template('collectd/etc/collectd/conf.d/rabbitmq.conf.erb'),
    require => Package['collectd-rabbitmq'],
  }
}
