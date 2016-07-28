# == Class: govuk::apps::specialist_publisher_rebuild
#
# A rebuild of specialist-publisher, a publishing app for specialist documents and manuals.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3123
#
# [*custom_http_host*]
#   This setting allows the default HTTP Host header to be overridden.
#
#   An example of where this is useful is if requests are handled by different
#   backend applications but use the same hostname.
#   Default: undef
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*errbit_api_key*]
#   Errbit API key for sending errors.
#   Default: undef
#
# [*enabled*]
#   A flag to toggle the app's existence on different environments.
#   Default: false
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*publish_pre_production_finders*]
#   Whether to enable publishing of pre-production finders
#   Default: false
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
#   Enables the sidekiq background worker.
#   Default: true
#
# [*secret_token*]
#   Used to set the app ENV var SECRET_TOKEN which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start. SECRET_TOKEN is used rather than SECRET_KEY_BASE so that
#   specialist publisher rebuild can share signed cookies with version 1.
#   Default: undef
#
class govuk::apps::specialist_publisher_rebuild(
  $port = 3123,
  $asset_manager_bearer_token = undef,
  $errbit_api_key = undef,
  $email_alert_api_bearer_token = undef,
  $enabled = false,
  $mongodb_nodes,
  $mongodb_name,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publish_pre_production_finders = false,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $secret_token = undef,
) {
  $app_name = 'specialist-publisher-rebuild'
  $app_domain = hiera('app_domain')

  if $enabled {
    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      custom_http_host   => "specialist-publisher.${app_domain}",
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
      asset_pipeline     => true,
    }

    govuk::procfile::worker {'specialist-publisher-rebuild':
      enable_service => $enable_procfile_worker,
    }

    govuk_logging::logstream { 'specialist-publisher-rebuild_sidekiq_json_log':
      logfile => '/var/apps/specialist-publisher-rebuild/log/sidekiq.json.log',
      fields  => {'application' => 'specialist-publisher-rebuild'},
      json    => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-ASSET_MANAGER_BEARER_TOKEN":
        varname => 'ASSET_MANAGER_BEARER_TOKEN',
        value   => $asset_manager_bearer_token;
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
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

    if $publish_pre_production_finders {
      govuk::app::envvar {
        "${title}-PUBLISH_PRE_PRODUCTION_FINDERS":
          varname => 'PUBLISH_PRE_PRODUCTION_FINDERS',
          value   => '1';
      }
    }

    if $secret_token != undef {
      govuk::app::envvar { "${title}-SECRET_TOKEN":
        varname => 'SECRET_TOKEN',
        value   => $secret_token,
      }
    }
  }
}
