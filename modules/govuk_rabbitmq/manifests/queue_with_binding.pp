# == Define: govuk_rabbitmq::queue_with_binding
#
# Creates a RabbitMQ queue, binds it to an exchange, and monitors it.
# Users should be set up separately: when doing so, you need to include
# read/write/configure permissions for the queue.
#
# === Modifying queues and bindings
#
# The provider for the rabbitmq_binding resource identifies instances without reference to the routing key.
# This makes it rather awkward to add or change bindings on any queue which already has a binding, because the
# provider will think the binding already exists even if the routing keys differ, and will assume
# that no work needs doing.
# At present the workaround for changing a binding is to create a new queue for the new binding. Then switch the
# consumers over to the new queue, and remove the old queue.
# Another side effect of this problem is you can't define more than one binding for a queue.
# This is possible in version 6.0.0, however that version also drops Puppet 3 support.
# https://forge.puppet.com/puppet/rabbitmq/changelog
#
# govuk_rabbitmq::remove_queues and govuk_rabbitmq::remove_bindings can be used
# to ensure old queues and bindings are cleaned up.
#
# === Parameters
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to configure permissions for.
#
# [*amqp_queue*]
#   The RabbitMQ queue to create and configure permissions for.
#
# [*routing_key*]
#   The routing key to create a binding for on the RabbitMQ queue.
#
# [*durable*]
#   Queues can be durable or transient. Durable queues survive broker restart, transient queues do not.
#   (default: true)
#
# [*arguments*]
#   The hash of arguments to configure the queue.
#
define govuk_rabbitmq::queue_with_binding (
  $amqp_exchange,
  $amqp_queue,
  $routing_key,
  $durable = true,
  $ensure = 'present',
  $arguments = {}
) {
  validate_re($routing_key, '^.+$', '$routing_key must be non-empty')
  $amqp_user = $title

  rabbitmq_queue { "${amqp_queue}@/":
    ensure      => $ensure,
    user        => 'root',
    password    => $::govuk_rabbitmq::root_password,
    durable     => $durable,
    auto_delete => false,
    arguments   => $arguments,
  } ->
  rabbitmq_binding { "binding_${routing_key}_${amqp_exchange}@${amqp_queue}@/":
    ensure           => $ensure,
    name             => "${amqp_exchange}@${amqp_queue}@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => $routing_key,
    arguments        => {},
  }

  govuk_rabbitmq::monitor_consumers {"${title}_${amqp_queue}_consumer_monitoring":
    ensure            => $ensure,
    rabbitmq_hostname => 'localhost',
    rabbitmq_queue    => $amqp_queue,
  }
}
