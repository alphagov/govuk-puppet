# == Class: govuk::apps::content_performance_manager::rabbitmq
#
# Permissions for the content_performance_manager to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'content_performance_manager')
#
# [*amqp_pass*]
#   The RabbitMQ password. This is a required parameter.
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'content_performance_manager')
#
class govuk::apps::content_performance_manager::rabbitmq (
  $amqp_user  = 'content_performance_manager',
  $amqp_pass,
  $amqp_exchange = 'published_documents',
  $amqp_queue = 'content_performance_manager',
) {

  govuk_rabbitmq::queue_with_binding { $amqp_queue:
    ensure        => 'absent',
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $amqp_queue,
    routing_key   => '*.#.#',
    durable       => true,
  } ->

  govuk_rabbitmq::consumer { $amqp_user:
    ensure               => 'absent',
    amqp_pass            => $amqp_pass,
    read_permission      => "^${amqp_queue}\$",
    write_permission     => "^\$",
    configure_permission => "^\$",
  }
}
