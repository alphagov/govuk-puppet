# == Class: govuk::apps::travel_advice_publisher
#
# App to publish travel advice.
#
# === Parameters
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*enable_email_alerts*]
#   Send email alerts via the email-alert-api
#   Default: false
#
# [*enable_procfile_worker*]
#   Enables the sidekiq background worker.
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: undef
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3035
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
# [*show_historical_edition_link*]
#   Feature flag for showing in-app historical previews.
#
class govuk::apps::travel_advice_publisher(
  $asset_manager_bearer_token = undef,
  $enable_email_alerts = false,
  $enable_procfile_worker = true,
  $errbit_api_key = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port = '3035',
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $show_historical_edition_link = false,
) {
  $app_name = 'travel-advice-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app     => $app_name,
  }

  if $mongodb_nodes != undef {
    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
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
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }

  validate_bool($show_historical_edition_link)
  if ($show_historical_edition_link) {
    govuk::app::envvar {
      "${title}-SHOW_HISTORICAL_EDITION_LINK":
        varname => 'SHOW_HISTORICAL_EDITION_LINK',
        value   => '1';
    }
  }

  validate_bool($enable_email_alerts)
  if ($enable_email_alerts) {
    govuk::app::envvar {
      "${title}-SEND_EMAIL_ALERTS":
        varname => 'SEND_EMAIL_ALERTS',
        value   => '1';
    }
  }

  validate_bool($enable_procfile_worker)
  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }
}
