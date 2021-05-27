# == Class: govuk::apps::account_api::rabbitmq
#
# Permissions for account-api to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'account_api')
#
# [*amqp_pass*]
#   The RabbitMQ password.
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'account_api')
#
class govuk::apps::account_api::rabbitmq (
  $enabled = false,
  $amqp_user  = 'account_api',
  $amqp_pass = 'account_api',
  $amqp_exchange = 'published_documents',
  $amqp_queue = 'account_api',
) {
  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  govuk_rabbitmq::queue_with_binding { $amqp_queue:
    ensure        => $ensure,
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $amqp_queue,
    routing_key   => '*.major',
    durable       => true,
  }

  rabbitmq_binding { "binding_minor_${amqp_exchange}@${amqp_queue}@/":
    ensure           => $ensure,
    name             => "${amqp_exchange}@${amqp_queue}@minor@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.minor',
    arguments        => {},
    require          => Govuk_rabbitmq::Queue_with_binding[$amqp_queue],
  }

  rabbitmq_binding { "binding_republish_${amqp_exchange}@${amqp_queue}@/":
    ensure           => $ensure,
    name             => "${amqp_exchange}@${amqp_queue}@republish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.republish',
    arguments        => {},
    require          => Govuk_rabbitmq::Queue_with_binding[$amqp_queue],
  }

  rabbitmq_binding { "binding_unpublish_${amqp_exchange}@${amqp_queue}@/":
    ensure           => $ensure,
    name             => "${amqp_exchange}@${amqp_queue}@unpublish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.unpublish',
    arguments        => {},
    require          => Govuk_rabbitmq::Queue_with_binding[$amqp_queue],
  }

  govuk_rabbitmq::consumer { $amqp_user:
    ensure               => $ensure,
    amqp_pass            => $amqp_pass,
    read_permission      => "^${amqp_queue}\$",
    write_permission     => "^\$",
    configure_permission => "^\$",
  }
}
