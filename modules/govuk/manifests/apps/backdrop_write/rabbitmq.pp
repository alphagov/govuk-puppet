# == Class: govuk::apps::backdrop_write::rabbitmq
#
# Permissions for the backdrop_write application to write messages to and the
# Procfile worker read from Backdrop's AMQP exchange.
#
# Note that stagecraft and backdrop_write rabbitmq config is deliberately different
# from our regular govuk_rabbitmq module. This is because the queues are managed by
# celery rather than using our standard ruby gem, and the performance platform project
# is still in alpha and therefore needs more flexibility.
# When performance platform enters beta we expect it to update its config to match the
# usual pattern (or possibly to stop using rabbitmq at all).
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
# [*amqp_vhost*]
#   The virtual host that this application is restricted to
#   Default: backdrop_write
#
class govuk::apps::backdrop_write::rabbitmq (
  $amqp_user  = 'backdrop_write',
  $amqp_pass  = 'backdrop_write',
  $amqp_vhost = 'backdrop_write',
) {

  rabbitmq_vhost { "/${amqp_vhost}":
    ensure   => present,
  }

  rabbitmq_user { $amqp_user:
    admin    => false,
    password => $amqp_pass,
  }

  rabbitmq_user_permissions { "${amqp_user}@/${amqp_vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user_permissions { "${govuk_rabbitmq::monitoring_user}@/${amqp_vhost}":
    read_permission      => '.*',
  }
}
