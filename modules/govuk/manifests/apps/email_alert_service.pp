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
#   Whether or not to configure the queue for the unpublishing processor
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
  $enable_unpublishing_queue_consumer = false
) {

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  $app_name = 'email-alert-service'

  govuk::app { 'email-alert-service':
    ensure             => $ensure,
    app_type           => 'bare',
    enable_nginx_vhost => false,
    sentry_dsn         => $sentry_dsn,
    command            => 'bundle exec rake message_queues:major_change_consumer',
  }

  govuk::procfile::worker { 'email-alert-service-unpublishing-queue-consumer':
    setenv_as      => $app_name,
    enable_service => $enable_unpublishing_queue_consumer,
    process_type   => 'unpublishing-queue-consumer',
    process_regex  => '\/rake message_queues:unpublishing_consumer',
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
