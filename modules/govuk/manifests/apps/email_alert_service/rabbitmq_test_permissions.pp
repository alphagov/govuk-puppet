# == Class: govuk::apps::email_alert_service::rabbitmq_test_permissions
#
# Permissions for the email_alert_service to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user and the exchange, and permits read/write/configure
# to the queue and the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ test username (default: 'email_alert_service_test')
#
# [*amqp_pass*]
#   The RabbitMQ test password (default: 'email_alert_service_test')
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from.
#   Must be vhost-unique.
#   (default: 'email_alert_service_published_documents_test_exchange')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from.
#   Must be vhost-unique.
#   (default: 'email_alert_service_published_documents_test_queue')
#
class govuk::apps::email_alert_service::rabbitmq_test_permissions (
  $amqp_user  = 'email_alert_service_test',
  $amqp_pass  = 'email_alert_service_test',
  $amqp_exchange = 'email_alert_service_published_documents_test_exchange',
  $amqp_queue = 'email_alert_service_published_documents_test_queue',
) {

  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  govuk_rabbitmq::exchange { "${amqp_exchange}@/":
    type     => 'topic',
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
    write_permission     => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
    read_permission      => "^(amq\\.gen.*|${amqp_queue}|${amqp_exchange})$",
  }
}
