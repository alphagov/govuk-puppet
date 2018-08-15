# == Class: govuk::apps::content_data_admin
#
# Read more: https://github.com/alphagov/content_data_admin
#
# === Parameters
# [*port*]
#   What port should the app run on? Find the next free one in development-vm/Procfile
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions (in govuk-secrets)
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions (in govuk-secrets)
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
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
class govuk::apps::content_data_admin (
  $port                         = '3230',
  $enabled                      = false,
  $secret_key_base              = undef,
  $sentry_dsn                   = undef,
  $oauth_id                     = undef,
  $oauth_secret                 = undef,
  $db_username                  = 'content_data_admin',
  $db_hostname                  = undef,
  $db_port                      = undef,
  $db_allow_prepared_statements = undef,
  $db_password                  = undef,
  $db_name                      = 'content_data_admin_production',
) {
  $app_name = 'content-data-admin'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure            => $ensure,
    app_type          => 'rack',
    port              => $port,
    sentry_dsn        => $sentry_dsn,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck', # must return HTTP 200 for an unauthenticated request
    deny_framing      => true,
    asset_pipeline    => true,
  }

  Govuk::App::Envvar {
    app            => $app_name,
    ensure         => $ensure,
    notify_service => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type                      => 'postgresql',
      username                  => $db_username,
      password                  => $db_password,
      host                      => $db_hostname,
      port                      => $db_port,
      database                  => $db_name,
      allow_prepared_statements => $db_allow_prepared_statements,
    }
  }
}
