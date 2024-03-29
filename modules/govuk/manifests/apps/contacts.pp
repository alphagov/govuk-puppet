# == Class: govuk::apps::contacts
#
# Admin app to publish contact information.
#
# === Parameters
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: true
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
# [*vhost*]
#   Virtual host for this application.
#   Default: contacts-admin
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#   Default: undef
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#   Default: undef
#
# [*port*]
#   The port that the app is served on.
#   Default: 3051
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
#
# [*extra_aliases*]
#   Other vhosts on which the app is served.
#   Default: []
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for Distributed Lock.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Distributed Lock.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#   Default: undef
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
class govuk::apps::contacts(
  $db_name = 'contacts_production',
  $db_hostname = undef,
  $db_username = undef,
  $db_password = undef,
  $enabled = true,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $vhost = 'contacts-admin',
  $port,
  $vhost_protected = undef,
  $extra_aliases = [],
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'contacts'

  validate_array($extra_aliases)

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  govuk::app { 'contacts':
    ensure                     => $ensure,
    app_type                   => 'rack',
    vhost                      => $vhost,
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    vhost_protected            => $vhost_protected,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/contacts-admin'],
    vhost_aliases              => $extra_aliases,
    repo_name                  => 'contacts-admin',
    nginx_extra_config         => '
      # Don\'t ask for basic auth on SSO API pages so we can sync
      # permissions.
      location /auth/gds {
        auth_basic off;
        try_files $uri @app;
      }
    ',
  }

  unless $ensure == 'absent' {
    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        app     => $app_name,
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-GDS_SSO_OAUTH_ID":
        varname => 'GDS_SSO_OAUTH_ID',
        value   => $oauth_id;
      "${title}-GDS_SSO_OAUTH_SECRET":
        varname => 'GDS_SSO_OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }

    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }
}
