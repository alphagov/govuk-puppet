# == Class: govuk::apps::authenticating_proxy
#
# Provides authenticated access to the draft stack.
#
# Read more: https://github.com/alphagov/authenticating-proxy
#
# === Parameters
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
# [*port*]
#   The port that it is served on.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*govuk_upstream_uri*]
#   The URI of the upstream service that we proxy to.
#   Default: undef
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*jwt_auth_secret*]
#   The secret used to decode JWT authentication tokens. This value needs to be
#   shared with the publishing apps that generate the encoded tokens.
#
# [*signon_uri_scheme*]
#   Scheme to use for signon URI.
#   Default: 'https'
class govuk::apps::authenticating_proxy(
  $db_hostname = undef,
  $db_username = 'authenticating-proxy',
  $db_password = undef,
  $db_port = undef,
  $db_name = 'authenticating_proxy_production',
  $port,
  $sentry_dsn = undef,
  $govuk_upstream_uri = 'http://localhost:3054',
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $jwt_auth_secret = undef,
  $signon_uri_scheme = 'https',
) {
  $app_name = 'authenticating-proxy'

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  govuk::app::envvar::database_url { $app_name:
    type     => 'postgresql',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    port     => $db_port,
    database => $db_name,
  }

  govuk::app { $app_name:
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
  }

  if $govuk_upstream_uri {
    govuk::app::envvar {
      "${title}-GOVUK_UPSTREAM_URI":
          app     => $app_name,
          varname => 'GOVUK_UPSTREAM_URI',
          value   => $govuk_upstream_uri;
    }
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-JWT_AUTH_SECRET":
      varname => 'JWT_AUTH_SECRET',
      value   => $jwt_auth_secret,
  }
}
