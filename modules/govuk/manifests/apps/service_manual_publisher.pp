# == Class: govuk::apps::service_manual_publisher
#
# Publisher for the service manual
#
# === Parameters
#
# [*enabled*]
#   Whether to enable the app
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*port*]
#   The port that the app is served on.
#
class govuk::apps::service_manual_publisher(
  $enabled = false,
  $errbit_api_key = '',
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
    }
  }
}
