# == Class: govuk::apps::publishing_api
#
# An application to act as a central store for all publishing content
# on GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*content_store*]
#   Is a URL that tells publishing API which content store to save
#   published content in.
#
# [*draft_content_store*]
#   Is a URL that tells publishing API which content store to save
#   draft content in.
#
# [*suppress_draft_store_502_error*]
#   Suppresses "502 Bad Gateway" returned by nginx when publishing API
#   attempts to store draft content. This is intended to be used only
#   during development so that we're not forced to keep draft content
#   store running while testing unrelated features.
#   Default: ''
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
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
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*enable_procfile_worker*]
#   Enables the sidekiq background worker.
#   Default: true
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
class govuk::apps::publishing_api(
  $port = '3093',
  $content_store = '',
  $draft_content_store = '',
  $suppress_draft_store_502_error = '',
  $errbit_api_key = '',
  $secret_key_base = undef,
  $db_hostname = undef,
  $db_username = 'publishing_api',
  $db_password = undef,
  $db_name = 'publishing_api_production',
  $redis_host = undef,
  $redis_port = '6379',
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  $app_name = 'publishing-api'

  govuk::app { $app_name:
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
    legacy_logging    => false,
    deny_framing      => true,
  }

  govuk::procfile::worker {'publishing-api':
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-CONTENT_STORE":
      varname => 'CONTENT_STORE',
      value   => $content_store;
    "${title}-DRAFT_CONTENT_STORE":
      varname => 'DRAFT_CONTENT_STORE',
      value   => $draft_content_store;
    "${title}-SUPPRESS_DRAFT_STORE_502_ERROR":
      varname => 'SUPPRESS_DRAFT_STORE_502_ERROR',
      value   => $suppress_draft_store_502_error;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-REDIS_HOST":
      varname => 'REDIS_HOST',
      value   => $redis_host;
    "${title}-REDIS_PORT":
      varname => 'REDIS_PORT',
      value   => $redis_port;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
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
