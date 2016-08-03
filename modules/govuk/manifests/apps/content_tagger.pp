# == Class: govuk::apps::content_tagger
#
# App to tag content on GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#   Default: 3116
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
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
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
class govuk::apps::content_tagger(
  $port = '3116',
  $secret_key_base = undef,
  $errbit_api_key = '',
  $db_hostname = undef,
  $db_username = 'content_tagger',
  $db_password = undef,
  $db_name = 'content_tagger_production',
  $oauth_id = '',
  $oauth_secret = '',
  $publishing_api_bearer_token = undef,
  $redis_host = 'redis-1.backend',
  $redis_port = '6379',
  $enable_procfile_worker = true,
) {
  $app_name = 'content-tagger'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $secret_key_base {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-REDIS_HOST":
      varname => 'REDIS_HOST',
      value   => $redis_host;
    "${title}-REDIS_PORT":
      varname => 'REDIS_PORT',
      value   => $redis_port;
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

  govuk::procfile::worker { 'content-tagger':
    enable_service => $enable_procfile_worker,
  }
}
