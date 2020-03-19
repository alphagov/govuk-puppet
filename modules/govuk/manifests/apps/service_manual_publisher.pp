# == Class: govuk::apps::service_manual_publisher
#
# Publisher for the service manual
#
# === Parameters
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*port*]
#   The port that the app is served on.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*http_username*]
#   The http basic auth username when running on integration.
#   Default: undef
#
# [*http_password*]
#   The http basic auth password when running on integration.
#   Default: undef
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
# [*govuk_notify_template_id*]
#   The template ID used to send email via GOV.UK Notify.
#
class govuk::apps::service_manual_publisher(
  $db_hostname = 'postgresql-primary-1.backend',
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'service-manual-publisher_production',
  $db_password = undef,
  $db_username = 'service_manual_publisher',
  $sentry_dsn = undef,
  $oauth_id = '',
  $oauth_secret = '',
  $port = 3111,
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $asset_manager_bearer_token = undef,
  $http_username = undef,
  $http_password = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
) {

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  $app_name = 'service-manual-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    log_format_is_json => true,
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-ASSET_MANAGER_BEARER_TOKEN":
      varname => 'ASSET_MANAGER_BEARER_TOKEN',
      value   => $asset_manager_bearer_token;
    "${title}-HTTP_USERNAME":
      varname => 'HTTP_USERNAME',
      value   => $http_username;
    "${title}-HTTP_PASSWORD":
      varname => 'HTTP_PASSWORD',
      value   => $http_password;
    "${title}-GOVUK_NOTIFY_API_KEY":
      varname => 'GOVUK_NOTIFY_API_KEY',
      value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
      varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
      value   => $govuk_notify_template_id;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $::govuk_node_class !~ /^development$/ {
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
