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
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
class govuk::apps::email_alert_service(
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'email_alert_service',
  $rabbitmq_password = 'email_alert_service',
  $sentry_dsn = undef,
  $redis_host = undef,
  $email_alert_api_bearer_token = undef,
) {
  govuk::app { 'email-alert-service':
    app_type           => 'bare',
    enable_nginx_vhost => false,
    sentry_dsn         => $sentry_dsn,
    command            => './bin/email_alert_service',
  }

  Govuk::App::Envvar {
    app => 'email-alert-service',
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
