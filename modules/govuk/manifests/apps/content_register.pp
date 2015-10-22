# == Class: govuk::apps::content_register
#
# The register of all content created by publishing applications.
# Read more: https://github.com/alphagov/content-register
#
# === Parameters
#
# [*port*]
#   The port that content-register API is served on.
#   Default: 3077
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: content_register
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: content_register
#
class govuk::apps::content_register(
  $port = '3077',
  $enable_procfile_worker = true,
  $rabbitmq_hosts = 'localhost',
  $rabbitmq_user = 'content_register',
  $rabbitmq_password = 'content_register',
) {
  govuk::app { 'content-register':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  Govuk::App::Envvar {
    app => 'content-register',
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

  govuk::procfile::worker {'content-register':
    enable_service => $enable_procfile_worker,
  }
  govuk_rabbitmq::monitor_consumers {'content-register_rabbitmq-consumers':
    rabbitmq_queue => 'content_register',
  }
}
