# == Define: govuk_rabbitmq::consumer
#
# Creates a rabbitmq user with permissions typical for a consuming application.
# This gives read permissions on the exchange, and read/write/configure
# permissions on the queue.
#
# === Queue and Binding management
#
# '$ensure => absent' will remove the specified user, but will not affect queues and bindings.
# To remove these, refer to govuk_rabbitmq::remove_queues and govuk_rabbitmq::remove_bindings.
#
# The provider for the rabbitmq_binding resource identifies instances without reference to the routing key.
# This makes it rather awkward to add or change bindings on any queue which already has a binding, because the
# provider will think the binding already exists even if the routing keys differ, and will assume
# that no work needs doing.
# At present the workaround for changing a binding is to create a new queue for the new binding. Then switch the
# consumers over to the new queue, and remove the old queue.
# We don't anticipate any use cases that require multiple bindings on a single queue.
#
# === Parameters
#
# [*amqp_pass*]
#   The RabbitMQ password for the $title user.
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
# [*is_test_exchange*]
#   Whether the amqp_exchange is a test exchange (only used by the test suite).
#   When set to true, this will create the exchange, and give the amqp_user
#   write permission to it.
#   When false, we assume that since the exchange is not a test exchange, it will already have been created.
#   (default: false)
#
# [*exchange_type*]
#   The type of exchange to create if is_test_exchange is set.
#   (default: 'topic')
#
# [*ensure*]
#   Determines whether to create or delete the consumer.
#   (default: present)
#
define govuk_rabbitmq::consumer (
  $amqp_pass,
  $amqp_exchange,
  $amqp_queue,
  $routing_key,
  $is_test_exchange = false,
  $exchange_type = 'topic',
  $ensure = present,
) {
  validate_re($ensure, '^(present|absent)$', '$ensure must be "present" or "absent"')
  validate_re($routing_key, '^.+$', '$routing_key must be non-empty')

  $amqp_user = $title

  include ::govuk_rabbitmq

  if $is_test_exchange {
    govuk_rabbitmq::exchange { "${amqp_exchange}@/":
      ensure => $ensure,
      type   => $exchange_type,
    }
    $write_permission = "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})\$"
  } else {
    $write_permission = "^(amq\\.gen.*|${amqp_queue})\$"
  }

  if $ensure == present {
    rabbitmq_user { $amqp_user:
      ensure   => present,
      password => $amqp_pass,
    } ->
    rabbitmq_user_permissions { "${amqp_user}@/":
      ensure               => present,
      configure_permission => "^(amq\\.gen.*|${amqp_queue})\$",
      write_permission     => $write_permission,
      read_permission      => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})\$",
    }

    rabbitmq_queue { "${amqp_queue}@/":
      ensure      => present,
      user        => 'root',
      password    => $::govuk_rabbitmq::root_password,
      durable     => true,
      auto_delete => false,
      arguments   => {},
    } ->
    rabbitmq_binding { "binding_${routing_key}_${amqp_exchange}@${amqp_queue}@/":
      ensure           => present,
      name             => "${amqp_exchange}@${amqp_queue}@/",
      user             => 'root',
      password         => $::govuk_rabbitmq::root_password,
      destination_type => 'queue',
      routing_key      => $routing_key,
      arguments        => {},
    }

  } else {
    rabbitmq_user { $amqp_user:
      ensure   => absent,
    }
  }

  govuk_rabbitmq::monitor_consumers {"${title}_consumer_monitoring":
    ensure            => $ensure,
    rabbitmq_hostname => 'localhost',
    rabbitmq_queue    => $amqp_queue,
  }
}
