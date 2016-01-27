# == Class: govuk::apps::government_frontend
#
# Government Frontend is an app to serve content pages form the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#
# [*port*]
#   What port should the app run on?
#
class govuk::apps::government_frontend(
  $vhost,
  $port = '3090',
) {
  Govuk::App::Envvar {
    app => 'government-frontend',
  }

  govuk::app { 'government-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_ssl_only        => true,
    health_check_path     => '/healthcheck',
    legacy_logging        => false,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'government-frontend',
    vhost                 => $vhost,
  }
}
