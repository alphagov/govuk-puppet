# == Define: govuk_rabbitmq::consumer
#
# Creates a rabbitmq user with permissions typical for a consuming application.
# This gives read permissions on the exchange, and read/write/configure
# permissions on the queue.
#
# === Parameters
#
# [*namevar*]
#   The RabbitMQ username
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
define govuk_rabbitmq::consumer (
  $amqp_pass,
  $amqp_exchange,
  $amqp_queue,
  $is_test_exchange = false,
  $exchange_type = 'topic',
) {
  $amqp_user = $title

  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  if $is_test_exchange {
    govuk_rabbitmq::exchange { "${amqp_exchange}@/":
      type     => $exchange_type,
    }
    $write_permission = "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$"
  } else {
    $write_permission = "^(amq\\.gen.*|${amqp_queue})$"
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => "^(amq\\.gen.*|${amqp_queue})$",
    write_permission     => $write_permission,
    read_permission      => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
  }
}
