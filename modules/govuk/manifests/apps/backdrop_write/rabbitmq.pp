# == Class: govuk::apps::backdrop_write::rabbitmq
#
# Permissions for the backdrop_write application to write messages to and the
# Procfile worker read from Backdrop's AMQP exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The username for the RabbitMQ user
#   Default: backdrop_write
#
# [*amqp_pass*]
#   The password for the RabbitMQ user
#   Default: backdrop_write
#
# [*amqp_exchange*]
#   The exchange that this application will publish to
#   Default: backdrop_write
#
# [*amqp_queue*]
#   The queue that this application will read from
#   Default: backdrop_write
#
class govuk::apps::backdrop_write::rabbitmq (
  $amqp_user  = 'backdrop_write',
  $amqp_pass  = 'backdrop_write',
  $amqp_exchange = 'backdrop_write',
  $amqp_queue = 'backdrop_write',
) {

  rabbitmq_user { $amqp_user:
    admin    => false,
    password => $amqp_pass,
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => "^(amq\\.gen.*|${amqp_queue})$",
    read_permission      => "^(amq\\.gen.*|${amqp_exchange}|${amqp_queue})$",
    write_permission     => "^(amq\\.gen.*|${amqp_exchange}|${amqp_queue})$",
  }

  govuk_rabbitmq::exchange { "${amqp_exchange}@/":
    type     => 'topic',
  }

}
