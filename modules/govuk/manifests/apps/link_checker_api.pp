# == Class: govuk::apps::link_checker_api
#
# App details at: https://github.com/alphagov/link-checker-api
#
# === Parameters
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: false
#
# [*errbit_api_key*]
#   Errbit API key for sending errors.
#   Default: undef
#
# [*port*]
#   The port that it is served on.
#   Default: 3208
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*secret_token*]
#   Used to set the app ENV var SECRET_TOKEN which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
class govuk::apps::link_checker_api (
  $db_hostname = undef,
  $db_username = 'link_checker_api',
  $db_password = undef,
  $db_name = 'link_checker_api_production',
  $enabled = false,
  $errbit_api_key = undef,
  $port = 3208,
  $redis_host = undef,
  $redis_port = undef,
  $secret_token = undef,
) {
  $app_name = 'link-checker-api'

  if $enabled {

    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::app { $app_name:
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar { "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    }

    if $secret_token != undef {
      govuk::app::envvar { "${title}-SECRET_TOKEN":
        varname => 'SECRET_TOKEN',
        value   => $secret_token,
      }
    }

    if $::govuk_node_class != 'development' {
      govuk::app::envvar::database_url { $app_name:
        type     => 'postgresql',
        username => $db_username,
        password => $db_password,
        host     => $db_hostname,
        database => $db_name,
      }
    }
  }
}
