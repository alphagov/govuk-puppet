# == Class: govuk::apps::email_alert_service
#
# This is a message queue consumer that triggers email alerts when documents are
# published with a major change.
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: email_alert_service
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: email_alert_service
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*enable_unpublishing_queue_consumer*]
#   Whether or not to enable the unpublishing worker
#   Default: false
#
# [*enable_subscriber_list_update_queue_consumers*]
#   Whether or not to enable the update subscriber list update workers (for major and minor updates)
#   Default: false
#
class govuk::apps::email_alert_service(
  $enabled = false,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'email_alert_service',
  $rabbitmq_password = 'email_alert_service',
  $sentry_dsn = undef,
  $redis_host = undef,
  $email_alert_api_bearer_token = undef,
  $enable_unpublishing_queue_consumer = false,
  $enable_subscriber_list_update_queue_consumers = false,
) {

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  $app_name = 'email-alert-service'

  govuk::app { 'email-alert-service':
    ensure                 => $ensure,
    app_type               => 'bare',
    enable_nginx_vhost     => false,
    sentry_dsn             => $sentry_dsn,
    collectd_process_regex => 'email-alert-service/.*rake message_queues:major_change_consumer',
    command                => 'bundle exec rake message_queues:major_change_consumer',
  }

  govuk::procfile::worker { 'email-alert-service-unpublishing-queue-consumer':
    setenv_as      => $app_name,
    enable_service => $enable_unpublishing_queue_consumer,
    process_type   => 'unpublishing-queue-consumer',
    process_regex  => '\/rake message_queues:unpublishing_consumer',
  }

  govuk::procfile::worker { 'email-alert-service-subscriber-list-details-update-minor-consumer':
    setenv_as      => $app_name,
    enable_service => $enable_subscriber_list_update_queue_consumers,
    process_type   => 'subscriber-list-details-update-minor-consumer',
    process_regex  => '\/rake message_queues:subscriber_list_details_update_minor_consumer',
  }

  govuk::procfile::worker { 'email-alert-service-subscriber-list-details-update-major-consumer':
    setenv_as      => $app_name,
    enable_service => $enable_subscriber_list_update_queue_consumers,
    process_type   => 'subscriber-list-details-update-major-consumer',
    process_regex  => '\/rake message_queues:subscriber_list_details_update_major_consumer',
  }

  Govuk::App::Envvar {
    ensure          => $ensure,
    app             => 'email-alert-service',
    notify_service  => $enabled,
  }

  govuk::app::envvar::rabbitmq { 'email-alert-service':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::app::envvar::redis { 'email-alert-service':
    host => $redis_host,
  }

  govuk::app::envvar {
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
  }
}
