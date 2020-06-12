# == Class: govuk::apps::travel_advice_publisher
#
# App to publish travel advice.
#
# === Parameters
#
# [*ensure*]
#   Allow govuk app to be removed.
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_username*]
#   The username to use when logging to the MongoDB database,
#   only needed if the app uses documentdb rather than mongodb
#
# [*mongodb_password*]
#   The password to use when logging to the MongoDB database
#   only needed if the app uses documentdb rather than mongodb
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*port*]
#   The port that publishing API is served on.
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
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*link_checker_api_secret_token*]
#   The Link Checker API secret token.
#   Default: undef
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
class govuk::apps::travel_advice_publisher(
  $ensure = 'present',
  $asset_manager_bearer_token = undef,
  $enable_email_alerts = false,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $mongodb_username = '',
  $mongodb_password = '',
  $oauth_id = undef,
  $oauth_secret = undef,
  $port,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $show_historical_edition_link = false,
  $email_alert_api_bearer_token = undef,
  $link_checker_api_secret_token = undef,
  $link_checker_api_bearer_token = undef,
) {
  $app_name = 'travel-advice-publisher'

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  govuk::app { $app_name:
    ensure             => $ensure,
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    json_health_check  => true,
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
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

  unless $ensure == 'absent' {
    Govuk::App::Envvar {
      app     => $app_name,
    }

    if $mongodb_nodes != undef {
      govuk::app::envvar::mongodb_uri { $app_name:
        hosts    => $mongodb_nodes,
        database => $mongodb_name,
        username => $mongodb_username,
        password => $mongodb_password,
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
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      "${title}-LINK_CHECKER_API_SECRET_TOKEN":
          varname => 'LINK_CHECKER_API_SECRET_TOKEN',
          value   => $link_checker_api_secret_token;
      "${title}-LINK_CHECKER_API_BEARER_TOKEN":
          varname => 'LINK_CHECKER_API_BEARER_TOKEN',
          value   => $link_checker_api_bearer_token;
    }
  }
}
