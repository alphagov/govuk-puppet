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
class govuk::apps::email_alert_service(
  $rabbitmq_hosts = 'localhost',
  $rabbitmq_user = 'email_alert_service',
  $rabbitmq_password = 'email_alert_service',
) {
  govuk::app { 'email-alert-service':
    app_type           => 'bare',
    enable_nginx_vhost => false,
    command            => './bin/email_alert_service',
  }
  govuk_rabbitmq::monitor_consumers {'email-alert-service_rabbitmq-consumers':
    rabbitmq_queue     => 'email_alert_service',
  }

  Govuk::App::Envvar {
    app => 'email-alert-service',
  }

  govuk::app::envvar {
    "${title}-RABBITMQ_HOSTS":
      varname => 'RABBITMQ_HOSTS',
      value   => $rabbitmq_hosts;
    "${title}-RABBITMQ_VHOST":
      varname => 'RABBITMQ_VHOST',
      value   => '/';
    "${title}-RABBITMQ_USER":
      varname => 'RABBITMQ_USER',
      value   => $rabbitmq_user;
    "${title}-RABBITMQ_PASSWORD":
      varname => 'RABBITMQ_PASSWORD',
      value => $rabbitmq_password;
  }
}
