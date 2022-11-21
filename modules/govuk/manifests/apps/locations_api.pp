# == Class: govuk::apps::locations_api
##
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions
#
# [*os_places_api_key*]
#   API key used by Locations API to communicate with OS Places API
#
# [*os_places_api_secret*]
#   Corresponding secret for above OS Places API key.
#
# [*os_places_api_postcodes_per_second]
#   Rate the postcode update workers should query OS Places API at.
#
# [*port*]
#   What port should the app run on?
#
# [*enable_procfile_worker*]
#   Should the Foreman-based background worker be enabled by default. Set in
#   hiera.
#
# [*db_hostname*]
#   The hostname of the database server to use for in DATABASE_URL environment variable
#
# [*db_username*]
#   The username to use for the DATABASE_URL environment variable
#
# [*db_password*]
#   The password to use for the DATABASE_URL environment variable
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::locations_api (
  $enabled = false,
  $secret_key_base = undef,
  $os_places_api_key = undef,
  $os_places_api_secret = undef,
  $os_places_api_postcodes_per_second = '3',
  $port,
  $enable_procfile_worker = true,
  $unicorn_worker_processes = undef,
  $db_hostname = undef,
  $db_username = 'locations_api',
  $db_password = undef,
  $db_port = undef,
  $db_name = 'locations_api_production',
  $sentry_dsn = undef,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'locations-api'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    unicorn_worker_processes   => $unicorn_worker_processes,
    sentry_dsn                 => $sentry_dsn,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  Govuk::App::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OS_PLACES_API_KEY":
      varname => 'OS_PLACES_API_KEY',
      value   => $os_places_api_key;
    "${title}-OS_PLACES_API_SECRET":
      varname => 'OS_PLACES_API_SECRET',
      value   => $os_places_api_secret;
    "${title}-OS_PLACES_API_POSTCODES_PER_SECOND":
      varname => 'OS_PLACES_API_POSTCODES_PER_SECOND',
      value   => $os_places_api_postcodes_per_second;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar::database_url { $app_name:
    type     => 'postgresql',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    port     => $db_port,
    database => $db_name,
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }
}
