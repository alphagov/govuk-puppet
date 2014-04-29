class govuk::node::s_rabbitmq inherits govuk::node::s_base {
  include '::rabbitmq'

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
  }

  class { 'collectd::plugin::rabbitmq':  }

  @ufw::allow { 'allow-amqp-from-all':
    port => 5672,
  }
}
