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
# [*monitoring_host*]
#   The host of the RabbitMQ process.
#
class collectd::plugin::rabbitmq (
  $monitoring_password,
  $monitoring_host,
  $admin_port,
  ){

  @package { 'collectd-rabbitmq':
    ensure   => '1.20.0',
    provider => pip,
  }

  @collectd::plugin { 'rabbitmq':
    content => template('collectd/etc/collectd/conf.d/rabbitmq.conf.erb'),
    require => Package['collectd-rabbitmq'],
  }
}
