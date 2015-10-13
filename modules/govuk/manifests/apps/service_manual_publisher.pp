# == Class: govuk::apps::service_manual_publisher
#
# Publisher for the service manual
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
#   Whether to enable the app
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*port*]
#   The port that the app is served on.
#
class govuk::apps::service_manual_publisher(
  $db_hostname = 'postgresql-primary-1.backend',
  $db_name = 'service-manual-publisher_production',
  $db_password = undef,
  $db_username = 'service_manual_publisher',
  $enabled = false,
  $errbit_api_key = '',
  $oauth_id = '',
  $oauth_secret = '',
  $port = 3111,
) {

  if $enabled {
    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    $app_name = 'service-manual-publisher'

    govuk::app { $app_name:
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
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
