# == Class: govuk::apps::search_admin
#
# The GOV.UK application for managing "best bets" and "external links" along
# with other search and browse data.
#
# === Parameters
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*port*]
#   The port where the Rails app is running.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*rummager_bearer_token*]
#   The bearer token to use when communicating with Rummager.
#   Default: undef
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
# [*govuk_notify_template_id*]
#   The template ID used to send email via GOV.UK Notify.
#
# [*expiring_bets_mailing_list*]
#   The email address to send notifications of expiring bets to
#
class govuk::apps::search_admin(
  $db_hostname = undef,
  $db_name = undef,
  $db_password = undef,
  $db_username = undef,
  $sentry_dsn = undef,
  $port,
  $publishing_api_bearer_token = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $rummager_bearer_token = undef,
  $override_search_location = undef,
  $enable_procfile_worker = true,
  $redis_host = undef,
  $redis_port = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
  $expiring_bets_mailing_list = undef,
) {
  $app_name = 'search-admin'

  govuk::app { $app_name:
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_ssl_only           => true,
    health_check_path        => '/queries',
    log_format_is_json       => true,
    asset_pipeline           => true,
    deny_framing             => true,
    override_search_location => $override_search_location,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-RUMMAGER_BEARER_TOKEN":
      varname => 'RUMMAGER_BEARER_TOKEN',
      value   => $rummager_bearer_token;
    "${title}-GOVUK_NOTIFY_API_KEY":
      varname => 'GOVUK_NOTIFY_API_KEY',
      value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
      varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
      value   => $govuk_notify_template_id;
    "${title}-EXPIRING_BETS_MAILING_LIST":
      varname => 'EXPIRING_BETS_MAILING_LIST',
      value   => $expiring_bets_mailing_list;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  govuk::app::envvar::database_url { $app_name:
    type     => 'mysql2',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    database => $db_name,
  }
}
