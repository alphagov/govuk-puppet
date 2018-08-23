# == Class: govuk::apps::cache_clearing_service::rabbitmq
#
# Permissions for the cache_clearing_service to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'cache_clearing_service')
#
# [*amqp_pass*]
#   The RabbitMQ password. This is a required parameter.
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'cache_clearing_service')
#
class govuk::apps::cache_clearing_service::rabbitmq (
  $amqp_user  = 'cache_clearing_service',
  $amqp_pass = undef,
  $amqp_exchange = 'published_documents',
  $amqp_queue = 'cache_clearing_service',
) {
  govuk_rabbitmq::queue_with_binding { $amqp_queue:
    ensure        => 'present',
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $amqp_queue,
    routing_key   => '*.major',
    durable       => true,
  }

  rabbitmq_binding { "binding_minor_${amqp_exchange}@${amqp_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${amqp_queue}@minor@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.minor',
    arguments        => {},
  }

  rabbitmq_binding { "binding_links_${amqp_exchange}@${amqp_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${amqp_queue}@links@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.links',
    arguments        => {},
  }

  rabbitmq_binding { "binding_republish_${amqp_exchange}@${amqp_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${amqp_queue}@republish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.republish',
    arguments        => {},
  }

  rabbitmq_binding { "binding_unpublish_${amqp_exchange}@${amqp_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${amqp_queue}@unpublish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.unpublish',
    arguments        => {},
  }

  govuk_rabbitmq::consumer { $amqp_user:
    ensure               => 'present',
    amqp_pass            => $amqp_pass,
    read_permission      => "^${amqp_queue}\$",
    write_permission     => "^\$",
    configure_permission => "^\$",
  }
}
