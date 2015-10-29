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
# [*enable_service_manual*]
#   A feature flag to enable rendering Service Manual formats
#
class govuk::apps::government_frontend(
  $vhost,
  $port = '3090',
  $enable_service_manual = false,
) {
  Govuk::App::Envvar {
    app => 'government-frontend',
  }

  if $enable_service_manual {
    govuk::app::envvar {
      "${title}-FLAG_ENABLE_SERVICE_MANUAL":
        varname => 'FLAG_ENABLE_SERVICE_MANUAL',
        value   => '1';
    }
  }
  govuk::app { 'government-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_ssl_only        => true,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'government-frontend',
    vhost                 => $vhost,
  }
}
