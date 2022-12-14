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
# [*ensure*]
#   Ensure the RabbitMQ state is setup, or not.
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
# [*amqp_major_change_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'email_alert_service')
#
# [*amqp_unpublishing_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'email_unpublishing')
#
# [*queue_size_critical_threshold*]
#   The number of unprocessed messages which can build up before triggering
#   a critical alert.
#
# [*queue_size_warning_threshold*]
#   The number of unprocessed messages which can build up before triggering
#   a warning.
#
# [*rabbitmq_url*]
#   RabbitMQ URL, including username and password.
#   Default: ''
#
class govuk::apps::email_alert_service::rabbitmq (
  $ensure = 'present',
  $amqp_user  = 'email_alert_service',
  $amqp_pass  = 'email_alert_service',
  $amqp_exchange = 'published_documents',
  $amqp_major_change_queue = 'email_alert_service',
  $amqp_unpublishing_queue = 'email_unpublishing',
  $ampq_subscriber_list_update_minor_queue = 'subscriber_list_details_update_minor',
  $ampq_subscriber_list_update_major_queue = 'subscriber_list_details_update_major',
  $queue_size_critical_threshold,
  $queue_size_warning_threshold,
  $rabbitmq_url = '',
) {

  $monitor_consumers = govuk::apps::email_alert_service::monitor_rabbitmq_consumers

  govuk_rabbitmq::queue_with_binding { $amqp_major_change_queue:
    ensure            => $ensure,
    amqp_exchange     => $amqp_exchange,
    amqp_queue        => $amqp_major_change_queue,
    routing_key       => '*.major.#',
    durable           => true,
    monitor_consumers => $monitor_consumers,
  } ->

  govuk_rabbitmq::queue_with_binding { $ampq_subscriber_list_update_minor_queue:
    ensure            => $ensure,
    amqp_exchange     => $amqp_exchange,
    amqp_queue        => $ampq_subscriber_list_update_minor_queue,
    routing_key       => '*.minor.#',
    durable           => true,
    monitor_consumers => $monitor_consumers,
  } ->

  govuk_rabbitmq::queue_with_binding { $ampq_subscriber_list_update_major_queue:
    ensure            => $ensure,
    amqp_exchange     => $amqp_exchange,
    amqp_queue        => $ampq_subscriber_list_update_major_queue,
    routing_key       => '*.major.#',
    durable           => true,
    monitor_consumers => $monitor_consumers,
  } ->

  govuk_rabbitmq::queue_with_binding { $amqp_unpublishing_queue:
    ensure            => $ensure,
    amqp_exchange     => $amqp_exchange,
    amqp_queue        => $amqp_unpublishing_queue,
    routing_key       => '*.unpublish.#',
    durable           => true,
    monitor_consumers => $monitor_consumers,
  } ->

  govuk_rabbitmq::monitor_messages {"${amqp_major_change_queue}_message_monitoring":
    ensure             => $ensure,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $amqp_major_change_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->

  govuk_rabbitmq::monitor_messages {"${ampq_subscriber_list_update_minor_queue}_message_monitoring":
    ensure             => $ensure,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $ampq_subscriber_list_update_minor_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->


  govuk_rabbitmq::monitor_messages {"${ampq_subscriber_list_update_major_queue}_message_monitoring":
    ensure             => $ensure,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $ampq_subscriber_list_update_major_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->

  govuk_rabbitmq::monitor_messages {"${amqp_unpublishing_queue}_message_monitoring":
    ensure             => $ensure,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $amqp_unpublishing_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
  } ->

  govuk_rabbitmq::consumer { $amqp_user:
    ensure               => $ensure,
    amqp_pass            => $amqp_pass,
    read_permission      => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue}|${ampq_subscriber_list_update_minor_queue}|${ampq_subscriber_list_update_major_queue}|${amqp_exchange})\$",
    write_permission     => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue}|${ampq_subscriber_list_update_minor_queue}|${ampq_subscriber_list_update_major_queue})\$",
    configure_permission => "^(amq\\.gen.*|${amqp_major_change_queue}|${amqp_unpublishing_queue}|${ampq_subscriber_list_update_minor_queue}|${ampq_subscriber_list_update_major_queue})\$",
  }
}
