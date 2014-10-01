# == Class: govuk::apps::email_alert_service::rabbitmq_permissions
#
# Permissions for the email_alert_service to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'email_alert_service')
#
# [*amqp_pass*]
#   The RabbitMQ password (default: 'email_alert_service')
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'email_alert_service')
#
class govuk::apps::email_alert_service::rabbitmq_permissions (
  $amqp_user  = 'email_alert_service',
  $amqp_pass  = 'email_alert_service',
  $amqp_exchange = 'published_documents',
  $amqp_queue = 'email_alert_service',
) {

  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => "^(amq\\.gen.*|${amqp_queue})$",
    write_permission     => "^(amq\\.gen.*|${amqp_queue})$",
    read_permission      => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
  }
}
