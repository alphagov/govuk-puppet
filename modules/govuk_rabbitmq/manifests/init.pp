class govuk_rabbitmq {
  include '::rabbitmq'
  include govuk_rabbitmq::logging

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
  }

  class { 'collectd::plugin::rabbitmq': }

  @ufw::allow { 'allow-amqp-from-all':
    port => 5672,
  }
}
