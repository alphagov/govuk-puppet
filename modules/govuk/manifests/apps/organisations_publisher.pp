# == Class: govuk::apps::organisations_publisher
#
# Organisations Publisher exists to create and manage organisations,
# people and roles.
#
# Read more: https://github.com/alphagov/organisations-publisher
#
# === Parameters
#
# [*port*]
#   What port should the app run on?
#   Default: 3218
#
# [*enabled*]
#   Should the application be enabled? Set in hiera data for each
#   environment.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
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
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::organisations_publisher(
  $port = '3218',
  $enabled = false,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = '',
  $oauth_secret = '',
  $enable_procfile_worker = true,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'organisations-publisher'

  if $enabled {
    govuk::app { $app_name:
      ensure             => 'absent',
      app_type           => 'rack',
      port               => $port,
      sentry_dsn         => $sentry_dsn,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
      asset_pipeline     => true,
      deny_framing       => true,
    }

    govuk::procfile::worker { $app_name:
      enable_service => $enable_procfile_worker,
    }
  }
}
