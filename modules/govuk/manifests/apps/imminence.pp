# == Class: govuk::apps::imminence
#
# Imminence manages sets of (somewhat) structured data for use
# elsewhere on GOV.UK. It's primarily used for geographical data such
# as lists of registry offices, test centres, and the like. There is a
# simple JSON API for integrating the data with other applications.
#
# === Parameters
#
# [*ensure*]
#   Whether Imminence should be present or absent.
#
# [*port*]
#   The port that Imminence is served on.
#
# [*enable_procfile_worker*]
#   Whether to enable the Procfile worker.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
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
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*redis_host*]
#   Redis host for Sidekiq.
#
# [*redis_port*]
#   Redis port for Sidekiq.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
class govuk::apps::imminence(
  $ensure = 'present',
  $port,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $db_hostname = undef,
  $db_username = 'imminence',
  $db_password = undef,
  $db_port = undef,
  $db_name = 'imminence_production',
  $mongodb_nodes = undef,
  $mongodb_name = 'imminence_production',
  $redis_host = undef,
  $redis_port = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $unicorn_worker_processes = undef,
  $app_domain = undef,
) {

  $app_name = 'imminence'

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  Govuk::App::Envvar {
    ensure => $ensure,
    app    => $app_name,
  }

  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    asset_pipeline             => true,
    unicorn_worker_processes   => $unicorn_worker_processes,
    read_timeout               => 60,
  }

  govuk::app::envvar {
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  if $app_domain {
    govuk::app::envvar {
      "${title}-GOVUK_APP_DOMAIN":
      varname => 'GOVUK_APP_DOMAIN',
      value   => $app_domain;
      "${title}-GOVUK_APP_DOMAIN_EXTERNAL":
      varname => 'GOVUK_APP_DOMAIN_EXTERNAL',
      value   => $app_domain;
    }
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  govuk::app::envvar::database_url { $app_name:
    type     => 'postgis',
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
