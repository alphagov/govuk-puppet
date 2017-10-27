# == Class: govuk::apps::stagecraft::rabbitmq
#
# Permissions for the stagecraft application to write messages to and the
# Procfile worker read from Stagecraft's AMQP exchange.
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
#   Default: stagecraft
#
# [*amqp_pass*]
#   The password for the RabbitMQ user
#   Default: stagecraft
#
# [*amqp_vhost*]
#   The virtual host that this application is restricted to
#   Default: stagecraft
#
class govuk::apps::stagecraft::rabbitmq (
  $amqp_user  = 'stagecraft',
  $amqp_pass  = 'stagecraft',
  $amqp_vhost = 'stagecraft',
) {

  rabbitmq_vhost { "/${amqp_vhost}":
    ensure   => 'absent',
  }

  rabbitmq_user { $amqp_user:
    ensure   => 'absent',
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
