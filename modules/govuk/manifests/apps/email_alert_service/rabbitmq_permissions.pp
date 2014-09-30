# == Class: govuk::apps::email_alert_service::rabbitmq_permissions
#
# Permissions for the email_alert_service to read messages from
# the publishing API's AMQP exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'email_alert_service')
#
# [*amqp_pass*]
#   The RabbitMQ password (default: 'email_alert_service')
#
# [*amqp_read_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'email_alert_service')
#
# [*configure_test_permissions*]
#   Whether to set up permissions for a test exchange and queue (default: false)
#
class govuk::apps::email_alert_service::rabbitmq_permissions (
  $amqp_user  = 'email_alert_service',
  $amqp_pass  = 'email_alert_service',
  $amqp_read_exchange = 'published_documents',
  $amqp_queue = 'email_alert_service',
  $configure_test_permissions = false,
) {

  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  $queue_regex_fragment = $configure_test_permissions ? {
    true    => "${amqp_queue}|${amqp_queue}_test",
    default => $amqp_queue
  }

  $exchange_regex_fragment = $configure_test_permissions ? {
    true    => "${amqp_read_exchange}|${amqp_read_exchange}_test",
    default => $amqp_read_exchange
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => "^(amq\\.gen.*|${queue_regex_fragment})$",
    read_permission      => "^(amq\\.gen.*|${queue_regex_fragment}|${exchange_regex_fragment})$",
    write_permission     => "^(amq\\.gen.*|${queue_regex_fragment})$",
  }
}
