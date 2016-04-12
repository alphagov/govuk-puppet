# == Define: govuk_rabbitmq::consumer
#
# Creates a rabbitmq user with permissions typical for a consuming application.
# This gives read permissions on the exchange, and read/write/configure
# permissions on the queue.
#
# === Parameters
#
# [*amqp_pass*]
#   The RabbitMQ password
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to configure permissions for.
#
# [*amqp_queue*]
#   The RabbitMQ queue to configure permissions for.
#
# [*is_test_exchange*]
#   Whether the amqp_exchange is a test exchange (only used by the test suite).
#   When set to true, this will create the exchange, and give the amqp_user
#   write permission to it.
#   (default: false)
#
# [*exchange_type*]
#   The type of exchange to create if create_exchange is set.
#   (default: 'topic')
#
# [*ensure*]
#   Determines whether to create or delete the consumer.
#   (default: ensure)
#
define govuk_rabbitmq::consumer (
  $amqp_pass,
  $amqp_exchange,
  $amqp_queue,
  $is_test_exchange = false,
  $exchange_type = 'topic',
  $ensure = present,
) {
  validate_re($ensure, '^(present|absent)$', '$ensure must be "present" or "absent"')

  $amqp_user = $title

  if $is_test_exchange {
    govuk_rabbitmq::exchange { "${amqp_exchange}@/":
      ensure => $ensure,
      type   => $exchange_type,
    }
    $write_permission = "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$"
  } else {
    $write_permission = "^(amq\\.gen.*|${amqp_queue})$"
  }

  if $ensure == present {
    rabbitmq_user { $amqp_user:
      ensure   => present,
      password => $amqp_pass,
    } ->
    rabbitmq_user_permissions { "${amqp_user}@/":
      ensure               => present,
      configure_permission => "^(amq\\.gen.*|${amqp_queue})$",
      write_permission     => $write_permission,
      read_permission      => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
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
