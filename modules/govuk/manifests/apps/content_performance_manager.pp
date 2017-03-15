# == Class: govuk::apps::content_performance_manager
#
# App details at: https://github.com/alphagov/content-performance-manager
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3206
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*google_analytics_govuk_view_id*]
#   The view id of GOV.UK in Google Analytics
#   Default: undef
#
# [*google_private_key*]
#   Google authentication private key
#   Default: undef
#
# [*google_client_email*]
#   Google authentication email
#   Default: undef
#
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::content_performance_manager(
  $port = '3206',
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $google_analytics_govuk_view_id = undef,
  $google_private_key = undef,
  $google_client_email = undef,
  $db_hostname = undef,
  $db_username = 'content_performance_manager',
  $db_password = undef,
  $db_name = 'content_performance_manager_production',
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
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $::govuk_node_class != 'development' {
    govuk::app::envvar::database_url { $app_name:
      type     => 'postgresql',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }
}
