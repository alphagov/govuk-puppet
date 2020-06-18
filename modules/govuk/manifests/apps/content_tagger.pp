# == Class: govuk::apps::content_tagger
#
# App to tag content on GOV.UK.
#
# === Parameters
#
## [*ensure*]
#   Allow govuk app to be removed.
#
# [*port*]
#   The port that the app is served on.
#   Default: 3116
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
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
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with the email-alert-api.
#   Default: undef
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
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
class govuk::apps::content_tagger(
  $ensure = 'present',
  $port,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $db_hostname = undef,
  $db_username = 'content_tagger',
  $db_password = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'content_tagger_production',
  $oauth_id = '',
  $oauth_secret = '',
  $email_alert_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $override_search_location = undef
) {
  $app_name = 'content-tagger'

  govuk::app { $app_name:
    ensure                   => $ensure,
    app_type                 => 'rack',
    port                     => $port,
    vhost_ssl_only           => true,
    health_check_path        => '/healthcheck',
    log_format_is_json       => true,
    asset_pipeline           => true,
    deny_framing             => false,
    sentry_dsn               => $sentry_dsn,
    override_search_location => $override_search_location,
  }

  govuk::procfile::worker { 'content-tagger':
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  unless $ensure == 'absent' {
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
      "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    }

    govuk::app::envvar::database_url { $app_name:
      type                      => 'postgresql',
      username                  => $db_username,
      password                  => $db_password,
      host                      => $db_hostname,
      port                      => $db_port,
      allow_prepared_statements => $db_allow_prepared_statements,
      database                  => $db_name,
    }

  }
}
