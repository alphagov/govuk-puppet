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
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default ['localhost']
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default 'account_api'
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default 'account_api'
#
# [*enable_publishing_queue_listener*]
#   Run the worker which processes publishing updates.
#   Default: false
#
# [*account_oauth_client_id*]
#   Client ID for the Transition Checker in GOV.UK Account Manager
#
# [*account_oauth_client_secret*]
#   Client secret for the Transition Checker in GOV.UK Account Manager
#
# [*plek_account_manager_uri*]
#   Path to the GOV.UK Account Manager
#
# [*session_signing_key*]
#   Secret key to sign user session data with
#
class govuk::apps::account_api (
  $port,
  $enabled = true,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_username = 'account-api',
  $db_hostname = undef,
  $db_port = undef,
  $db_password = undef,
  $db_name = 'account-api_production',
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'account_api',
  $rabbitmq_password = 'account_api',
  $enable_publishing_queue_listener = false,
  $account_oauth_client_id = undef,
  $account_oauth_client_secret = undef,
  $plek_account_manager_uri = undef,
  $session_signing_key = undef,
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
    "${title}-ACCOUNT-OAUTH-CLIENT-ID":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_ID',
        value   => $account_oauth_client_id;
    "${title}-ACCOUNT-OAUTH-CLIENT-SECRET":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_SECRET',
        value   => $account_oauth_client_secret;
    "${title}-PLEK-ACCOUNT-MANAGER-URI":
        varname => 'PLEK_SERVICE_ACCOUNT_MANAGER_URI',
        value   => $plek_account_manager_uri;
    "${title}-SESSION_SIGNING_KEY":
        varname => 'SESSION_SIGNING_KEY',
        value   => $session_signing_key;
  }

  govuk::app::envvar::rabbitmq { 'account-api':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::procfile::worker { 'account-api-publishing-queue-listener':
    setenv_as      => $app_name,
    enable_service => $enable_publishing_queue_listener,
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
