# == Class: govuk::apps::service_manual_publisher
#
# Publisher for the service manual
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#
# [*enabled*]
#   Whether to enable the app
#
class govuk::apps::service_manual_publisher(
  $port = 3111,
  $enabled = false,
) {

  if $enabled {
    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::app { 'service-manual-publisher':
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }
  }
}
