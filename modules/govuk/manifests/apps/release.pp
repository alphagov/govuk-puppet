# == Class: govuk::apps::publishing_api
#
# An application to manage releases on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port that the release app is served on.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
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
# [*github_username*]
#   The username to use when accessing the Github API.
#
# [*github_access_token*]
#   The access token to use when accessing the Github API.
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
class govuk::apps::release(
  $port,
  $enabled = true,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $db_hostname = undef,
  $db_username = undef,
  $db_password = undef,
  $db_name = 'release_production',
  $github_username = undef,
  $github_access_token = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  $app_name = 'release'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
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
  }

  Govuk::App::Envvar {
    app    => $app_name,
    ensure => $ensure,
  }

  govuk::app::envvar {
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-GITHUB_USERNAME":
      varname => 'GITHUB_USERNAME',
      value   => $github_username;
    "${title}-GITHUB_ACCESS_TOKEN":
      varname => 'GITHUB_ACCESS_TOKEN',
      value   => $github_access_token;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  govuk::app::envvar::database_url { $app_name:
    type     => 'mysql2',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    database => $db_name,
  }
}
