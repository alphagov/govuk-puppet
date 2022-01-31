# == Class: govuk::apps::account_api
#
# Read more: https://github.com/alphagov/account-api
#
# === Parameters
# [*port*]
#   What port the app should run on.
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*db_hostname*]
#   The hostname of the database server to use for in DATABASE_URL environment variable
#
# [*db_username*]
#   The username to use for the DATABASE_URL environment variable
#
# [*db_password*]
#   The password to use for the DATABASE_URL environment variable
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
# [*enable_procfile_worker*]
#   Run the sidekiq worker.
#   Default: false
#
# [*account_oauth_provider_uri*]
#   URI of the OAuth / OpenID Connect provider.
#   "#{account_oauth_provider_uri}/.well-known/openid-configuration" should exist.
#
# [*account_oauth_client_id*]
#   Client ID for the Transition Checker in GOV.UK Account Manager
#
# [*account_oauth_client_secret*]
#   Client secret for the Transition Checker in GOV.UK Account Manager
#
# [*account_oauth_private_key*]
#   RSA private key for communication with the Digital Identity auth service.
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*publishing_api_bearer_token*]
#   Bearer token for communication with the publishing-api
#
# [*session_secret*]
#   Secret used to secure user session data
#
# [*govuk_notify_api_key*]
#   API key for GOV.UK Notify
#
# [*govuk_notify_template_id*]
#   Template ID for GOV.UK Notify
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::account_api (
  $port,
  $enabled = true,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $unicorn_worker_processes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_username = 'account-api',
  $db_hostname = undef,
  $db_port = undef,
  $db_password = undef,
  $db_name = 'account-api_production',
  $enable_procfile_worker = false,
  $account_oauth_provider_uri = undef,
  $account_oauth_client_id = undef,
  $account_oauth_client_secret = undef,
  $account_oauth_private_key = undef,
  $email_alert_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $session_secret = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'account-api'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    deny_framing               => true,
    asset_pipeline             => true,
    unicorn_worker_processes   => $unicorn_worker_processes,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  Govuk::App::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-ACCOUNT-OAUTH-PROVIDER-URI":
        varname => 'GOVUK_ACCOUNT_OAUTH_PROVIDER_URI',
        value   => $account_oauth_provider_uri;
    "${title}-ACCOUNT-OAUTH-CLIENT-ID":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_ID',
        value   => $account_oauth_client_id;
    "${title}-ACCOUNT-OAUTH-CLIENT-SECRET":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_SECRET',
        value   => $account_oauth_client_secret;
    "${title}-ACCOUNT-OAUTH-PRIVATE_KEY":
        varname => 'GOVUK_ACCOUNT_OAUTH_PRIVATE_KEY',
        value   => $account_oauth_private_key;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-SESSION_SECRET":
        varname => 'SESSION_SECRET',
        value   => $session_secret;
    "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
  }

  govuk::app::envvar::redis { 'account-api':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::procfile::worker {'account-api':
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  govuk::procfile::worker { 'account-api-publishing-queue-listener':
    ensure         => 'absent',
    setenv_as      => $app_name,
    enable_service => false,
    process_type   => 'publishing-queue-listener',
    process_regex  => '\/rake message_queue:consumer',
  }

  govuk::app::envvar::database_url { $app_name:
    type     => 'postgresql',
    username => $db_username,
    password => $db_password,
    host     => $db_hostname,
    port     => $db_port,
    database => $db_name,
  }
}
