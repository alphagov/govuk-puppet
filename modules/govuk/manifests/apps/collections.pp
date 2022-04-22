# == Class: govuk::apps::collections
#
# Collections is an app to serve collection pages from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: collections
#
# [*port*]
#   What port should the app run on?
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*memcache_servers*]
#   URL of a shared memcache cluster.
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
class govuk::apps::collections(
  $vhost = 'collections',
  $port,
  $unicorn_worker_processes = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $email_alert_api_bearer_token = undef,
  $memcache_servers = undef,
  $google_tag_manager_id = undef,
  $google_tag_manager_preview = undef,
  $google_tag_manager_auth = undef,
) {
  govuk::app { 'collections':
    app_type                   => 'rack',
    port                       => $port,
    unicorn_worker_processes   => $unicorn_worker_processes,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/collections'],
    vhost                      => $vhost,
    sentry_dsn                 => $sentry_dsn,
  }

  Govuk::App::Envvar {
    app => 'collections',
  }

  govuk::app::envvar {
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-GOOGLE_TAG_MANAGER_ID":
        varname => 'GOOGLE_TAG_MANAGER_ID',
        value   => $google_tag_manager_id;
    "${title}-GOOGLE_TAG_MANAGER_PREVIEW":
        varname => 'GOOGLE_TAG_MANAGER_PREVIEW',
        value   => $google_tag_manager_preview;
    "${title}-GOOGLE_TAG_MANAGER_AUTH":
        varname => 'GOOGLE_TAG_MANAGER_AUTH',
        value   => $google_tag_manager_auth;
    # MEMCACHE_SERVERS is used by "Dalli", our memcached client gem
    # https://github.com/petergoldstein/dalli/blob/1fbef3c/lib/dalli/client.rb#L35
    "${title}-MEMCACHE_SERVERS":
        varname => 'MEMCACHE_SERVERS',
        value   => $memcache_servers;
  }
}
