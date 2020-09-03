# == Class: govuk::apps::transition
#
# Managing mappings (eg redirects) for sites moving to GOV.UK.
#
# === Parameters
#
# [*ensure*]
#   Allow govuk app to be removed.
#
# [*port*]
#   The port that transition is served on.
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
# [*aws_access_key_id*]
#   The Access Key ID for AWS to access S3 buckets.
#
# [*aws_secret_access_key*]
#   The Secret Access Key for AWS to access S3 buckets.
#
# [*aws_region*]
#   The Region for AWS to access S3 buckets.
#
class govuk::apps::transition(
  $ensure = 'present',
  $port,
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $basic_auth_username = undef,
  $basic_auth_password = undef,
  $db_hostname = undef,
  $db_username = 'transition',
  $db_password = undef,
  $db_name = 'transition_production',
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
) {
  $app_name = 'transition'

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  include govuk_postgresql::client
  govuk::app { $app_name:
    ensure             => $ensure,
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
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  unless $ensure == 'absent' {
    Govuk::App::Envvar {
      app    => $app_name,
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
      database => $db_name,
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
        "${title}-AWS_ACCESS_KEY_ID":
          varname => 'AWS_ACCESS_KEY_ID',
          value   => $aws_access_key_id;
        "${title}-AWS_SECRET_ACCESS_KEY":
          varname => 'AWS_SECRET_ACCESS_KEY',
          value   => $aws_secret_access_key;
        "${title}-AWS_REGION":
          varname => 'AWS_REGION',
          value   => $aws_region;
      }
    }
  }
}
