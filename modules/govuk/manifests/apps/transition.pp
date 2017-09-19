# == Class: govuk::apps::transition
#
# Managing mappings (eg redirects) for sites moving to GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that transition is served on.
#   Default: 3044
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*oauth_id*]
#   The Signon OAuth identifier for this app
#
# [*oauth_secret*]
#   The Signon OAuth secret for this app
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*basic_auth_username*]
#   The username to use for Basic Auth
#
# [*basic_auth_password*]
#   The password to use for Basic Auth
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
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
class govuk::apps::transition(
  $port = '3044',
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $basic_auth_username = undef,
  $basic_auth_password = undef,
  $errbit_api_key = undef,
  $db_hostname = undef,
  $db_username = 'transition',
  $db_password = undef,
  $db_name = 'transition_production',
) {
  $app_name = 'transition'

  include govuk_postgresql::client
  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    deny_framing       => true,
    asset_pipeline     => true,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $::govuk_node_class !~ /^(development|training)$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'postgresql',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      "${title}-BASIC_AUTH_USERNAME":
        varname => 'BASIC_AUTH_USERNAME',
        value   => $basic_auth_username;
      "${title}-BASIC_AUTH_PASSWORD":
        varname => 'BASIC_AUTH_PASSWORD',
        value   => $basic_auth_password;
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    }
  }
}
