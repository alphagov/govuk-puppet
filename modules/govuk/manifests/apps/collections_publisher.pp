# == Class: govuk::apps::collections_publisher
#
# Publishes certain collection and tag formats requiring
# complicated UIs.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#
# [*oauth_id*]
#   Sets the OAuth ID used by gds-sso
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key used by gds-sso
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
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
# [*jwt_auth_secret*]
#   The secret used to encode JWT authentication tokens. This value needs to be
#   shared with authenticating-proxy which decodes the tokens.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::collections_publisher(
  $port = '3078',
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $enable_procfile_worker = true,
  $link_checker_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $db_hostname = undef,
  $db_username = 'collections_pub',
  $db_password = undef,
  $db_name = 'collections_publisher_production',
  $redis_host = undef,
  $redis_port = undef,
  $jwt_auth_secret = undef,
) {
  $app_name = 'collections-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $secret_key_base {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  govuk::app::envvar {
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-LINK_CHECKER_API_BEARER_TOKEN":
        varname => 'LINK_CHECKER_API_BEARER_TOKEN',
        value   => $link_checker_api_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-JWT_AUTH_SECRET":
      varname => 'JWT_AUTH_SECRET',
      value   => $jwt_auth_secret;
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }
}
