# == Class: govuk::apps::cache_clearing_service
#
# This is a message queue consumer application which clears Fastly and Varnish
# caches when new content is published.
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
class govuk::apps::cache_clearing_service (
  $enabled = false,
  $sentry_dsn = undef,
) {
  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::app { 'cache-clearing-service':
    ensure             => $ensure,
    app_type           => 'bare',
    enable_nginx_vhost => false,
    sentry_dsn         => $sentry_dsn,
    command            => './bin/cache_clearing_service',
  }

  Govuk::App::Envvar {
    ensure          => $ensure,
    app             => 'cache-clearing-service',
    notify_service  => $enabled,
  }
}
