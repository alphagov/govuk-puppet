# == Class: govuk::apps::email_alert_service::rabbitmq
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
# [*queue_size_critical_threshold*]
#   The number of unprocessed messages which can build up before triggering
#   a critical alert.
#
# [*queue_size_warning_threshold*]
#   The number of unprocessed messages which can build up before triggering
#   a warning.
#
class govuk::apps::email_alert_service::rabbitmq (
  $amqp_user  = 'email_alert_service',
  $amqp_pass  = 'email_alert_service',
  $amqp_exchange = 'published_documents',
  $amqp_major_change_queue = 'email_alert_service',
  $amqp_unpublishing_queue = 'email_unpublishing',
  $queue_size_critical_threshold,
  $queue_size_warning_threshold,
) {

  govuk_rabbitmq::queue_with_binding { $amqp_major_change_queue:
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $amqp_major_change_queue,
    routing_key   => '*.major.#',
    durable       => true,
  } ->

  govuk_rabbitmq::monitor_messages {"${amqp_major_change_queue}_message_monitoring":
    ensure             => present,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $amqp_major_change_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->

  govuk_rabbitmq::queue_with_binding { $amqp_unpublishing_queue:
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $amqp_unpublishing_queue,
    routing_key   => 'redirect.unpublish.#',
    durable       => true,
  } ->

  govuk_rabbitmq::monitor_messages {"${amqp_unpublishing_queue}_message_monitoring":
    ensure             => present,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $amqp_unpublishing_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->

  govuk_rabbitmq::consumer { $amqp_user:
    amqp_pass            => $amqp_pass,
    read_permission      => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue}|${amqp_exchange})\$",
    write_permission     => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue})\$",
    configure_permission => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue})\$",
  }
}
