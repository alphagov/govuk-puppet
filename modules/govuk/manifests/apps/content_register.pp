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
  $rabbitmq_hosts = ['localhost'],
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

  Govuk::App::Envvar {
    app => 'content-register',
  }

  govuk::app::envvar::rabbitmq { 'content-register':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::procfile::worker {'content-register':
    enable_service => $enable_procfile_worker,
  }
}
