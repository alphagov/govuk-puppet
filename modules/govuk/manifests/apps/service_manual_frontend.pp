# == Class: govuk::apps::service_manual_frontend
#
# Service Manual Frontend is an app to serve content pages for the service manual from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'service-manual-frontend'
#
# [*port*]
#   What port should the app run on?
#
class govuk::apps::service_manual_frontend(
  $vhost = 'service-manual-frontend',
  $port = 3122,
) {
  Govuk::App::Envvar {
    app => 'service-manual-frontend',
  }

  govuk::app { 'service-manual-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_ssl_only        => true,
    health_check_path     => '/healthcheck',
    legacy_logging        => false,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'service-manual-frontend',
    vhost                 => $vhost,
  }
}
