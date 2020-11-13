# == Class: govuk::apps::authenticating_proxy
#
# Provides authenticated access to the draft stack.
#
# Read more: https://github.com/alphagov/authenticating-proxy
#
# === Parameters
#
# [*mongodb_nodes*]
#   Array of mongo cluster hostnames for the application to connect to.
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
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
  $mongodb_nodes,
  $mongodb_name = 'authenticating_proxy_production',
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

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
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
