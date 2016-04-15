# == Define: govuk_rabbitmq::remove_bindings
#
# Removes the named rabbitmq bindings on a particular queue.
# Multiple bindings can be removed at once by passing an array.
#
# We do not attempt to detect the condition of attempting to bind and
# delete the same routing_key to a queue in a single puppet run,
# so for clarity this is best used adjacent to any other config for the same queue.
#
# === Parameters
#
# [*amqp_vhost*]
#   The RabbitMQ vhost from which to delete bindings.
#
# [*amqp_exchange*]
#   The RabbitMQ exchange from which to delete bindings.
#
# [*amqp_queue*]
#   The RabbitMQ queue from which to delete bindings.
#
define govuk_rabbitmq::remove_bindings (
  $amqp_vhost,
  $amqp_exchange,
  $amqp_queue,
) {

  $routing_key = $title

  rabbitmq_binding { "binding_${routing_key}_${amqp_exchange}@${amqp_queue}@${amqp_vhost}":
    ensure           => absent,
    name             => "${amqp_exchange}@${amqp_queue}@${amqp_vhost}",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => $routing_key,
  }
}
