# == Class: govuk::apps::content_performance_manager
#
# App details at: https://github.com/alphagov/content-performance-manager
#
# === Parameters
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*google_analytics_govuk_view_id*]
#   The view id of GOV.UK in Google Analytics
#   Default: undef
#
# [*google_client_email*]
#   Google authentication email
#   Default: undef
#
# [*google_private_key*]
#   Google authentication private key
#   Default: undef
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*port*]
#   The port that it is served on.
#   Default: 3206
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
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
class govuk::apps::content_performance_manager(
  $db_hostname = undef,
  $db_name = 'content_performance_manager_production',
  $db_password = undef,
  $db_username = 'content_performance_manager',
  $enable_procfile_worker = true,
  $google_analytics_govuk_view_id = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port = '3206',
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
) {
  $app_name = 'content-performance-manager'

  govuk::app { $app_name:
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/',
    asset_pipeline    => true,
  }

  Govuk::App::Envvar {
    app    => $app_name,
  }

  govuk::procfile::worker {$app_name:
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar {
    "${title}-GOOGLE_ANALYTICS_GOVUK_VIEW_ID":
      varname => 'GOOGLE_ANALYTICS_GOVUK_VIEW_ID',
      value   => $google_analytics_govuk_view_id;
    "${title}-GOOGLE_PRIVATE_KEY":
      varname => 'GOOGLE_PRIVATE_KEY',
      value   => $google_private_key;
    "${title}-GOOGLE_CLIENT_EMAIL":
      varname => 'GOOGLE_CLIENT_EMAIL',
      value   => $google_client_email;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
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
}
