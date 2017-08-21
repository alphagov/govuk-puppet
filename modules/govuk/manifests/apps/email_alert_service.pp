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
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
class govuk::apps::email_alert_service(
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'email_alert_service',
  $rabbitmq_password = 'email_alert_service',
  $errbit_api_key = undef,
) {
  govuk::app { 'email-alert-service':
    app_type           => 'bare',
    enable_nginx_vhost => false,
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

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
  }
}
