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
# [*enabled*]
#   Is the app enabled
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
class govuk::apps::service_manual_frontend(
  $vhost = 'service-manual-frontend',
  $port,
  $enabled = true,
  $sentry_dsn = undef,
  $secret_key_base = undef,
) {
  if $enabled {
    Govuk::App::Envvar {
      app => 'service-manual-frontend',
    }

    govuk::app { 'service-manual-frontend':
      app_type                => 'rack',
      port                    => $port,
      sentry_dsn              => $sentry_dsn,
      vhost_ssl_only          => true,
      health_check_path       => '/healthcheck',
      asset_pipeline          => true,
      asset_pipeline_prefixes => ['assets/service-manual-frontend'],
      vhost                   => $vhost,
    }

    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }
  }
}
