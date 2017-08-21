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
# [*create_queue*]
#   Can be used to skip queue creation, which is required if a queue is declared multiple times for different users.
#   (default: true)
#
# [*extra_read_permissions*]
#   Extra resource permissions to give the user.
#
# [*extra_write_permissions*]
#   Extra resource permissions to give the user.
#
# [*extra_configure_permissions*]
#   Extra resource permissions to give the user.
#
define govuk_rabbitmq::consumer (
  $amqp_pass,
  $amqp_exchange,
  $amqp_queue,
  $routing_key,
  $is_test_exchange = false,
  $exchange_type = 'topic',
  $ensure = present,
  $create_queue = true,
  $extra_read_permissions = undef,
  $extra_write_permissions = undef,
  $extra_configure_permissions = undef,
) {
  validate_re($ensure, '^(present|absent)$', '$ensure must be "present" or "absent"')
  validate_re($routing_key, '^.+$', '$routing_key must be non-empty')

  if $is_test_exchange {
    govuk_rabbitmq::exchange { "${amqp_exchange}@/":
      ensure => $ensure,
      type   => $exchange_type,
    }
  }

  # TODO:
  # It would be cleaner for the caller to set all the permissions
  if $extra_read_permissions != undef {
    $read_permission = "^(amq\\.gen.*|${extra_read_permissions}|${amqp_queue}|${amqp_exchange})\$"
  } else {
    $read_permission = "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})\$"
  }

  if $extra_write_permissions != undef {
    $write_permission = "^(amq\\.gen.*|${extra_write_permissions}|${amqp_queue})\$"
  } elsif $is_test_exchange {
    $write_permission = "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})\$"
  } else {
    $write_permission = "^(amq\\.gen.*|${amqp_queue})\$"
  }

  if $extra_configure_permissions != undef {
    $configure_permission = "^(amq\\.gen.*|${extra_configure_permissions}|${amqp_queue})\$"
  } else {
    $configure_permission = "^(amq\\.gen.*|${amqp_queue})\$"
  }

  $amqp_user = $title

  include ::govuk_rabbitmq

  if $ensure == present {
    rabbitmq_user { $amqp_user:
      ensure   => present,
      password => $amqp_pass,
    } ->
    rabbitmq_user_permissions { "${amqp_user}@/":
      ensure               => present,
      configure_permission => $configure_permission,
      write_permission     => $write_permission,
      read_permission      => $read_permission,
    }

    if $create_queue {
      govuk_rabbitmq::queue_with_binding { "$title":
        amqp_pass     => $amqp_pass,
        amqp_queue    => $amqp_queue,
        amqp_exchange => $amqp_exchange,
        routing_key   => $routing_key,
      }
    }
  } else {
    rabbitmq_user { $amqp_user:
      ensure   => absent,
    }
  }
}
