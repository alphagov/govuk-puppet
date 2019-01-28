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
# [*content_performance_manager_bearer_token*]
#   The bearer token to use when communicating with Content Performance Manager.
#   Default: undef
#
# [*google_tag_manager_id*]
#   The ID for the Google Tag Manager account
#
# [*google_tag_manager_preview*]
#   Allows a tag to be previewed in the Google Tag Manager interface
#
# [*google_tag_manager_auth*]
#   The identifier of an environment for Google Tag Manager
#
# [*read_timeout*]
# Configure the amount of time the nginx proxy vhost will wait for the
# backing app before it sends the client a 504. We override the default 15 seconds
# to 60.
#
class govuk::apps::content_data_admin (
  $port                         = '3230',
  $enabled                      = true,
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
  $content_performance_manager_bearer_token = undef,
  $google_tag_manager_id = undef,
  $google_tag_manager_preview = undef,
  $google_tag_manager_auth = undef,
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
    read_timeout      => 60,
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
    "${title}-CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN":
      varname => 'CONTENT_PERFORMANCE_MANAGER_BEARER_TOKEN',
      value   => $content_performance_manager_bearer_token;
    "${title}-GOOGLE_TAG_MANAGER_ID":
        varname => 'GOOGLE_TAG_MANAGER_ID',
        value   => $google_tag_manager_id;
    "${title}-GOOGLE_TAG_MANAGER_PREVIEW":
        varname => 'GOOGLE_TAG_MANAGER_PREVIEW',
        value   => $google_tag_manager_preview;
    "${title}-GOOGLE_TAG_MANAGER_AUTH":
        varname => 'GOOGLE_TAG_MANAGER_AUTH',
        value   => $google_tag_manager_auth;
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
