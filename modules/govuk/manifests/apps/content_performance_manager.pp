# == Class: govuk::apps::content_performance_manager
#
# App details at: https://github.com/alphagov/content-performance-manager
#
# === Parameters
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*etl_healthcheck_enabled*]
#   Enables or disables the ETL checks via the healthcheck endpoint
#   Default: false
#
# [*etl_healthcheck_enabled_from_hour*]
#   The hour of the day where ETL healthcheck alerts are enabled
#   Default: undef
#
# [*google_analytics_govuk_view_id*]
#   The view id of GOV.UK in Google Analytics
#   Default: undef
#
# [*google_client_email*]
#   Google authentication email
#   Default: undef
#
# [*google_private_key*]
#   Google authentication private key
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
# [*port*]
#   The port that it is served on.
#   Default: 3206
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   This is a required parameter
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   This is a required parameter
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*support_api_bearer_token*]
#   The bearer token that will be used to authenticate with support-api
#
class govuk::apps::content_performance_manager(
  $db_hostname = undef,
  $db_name = 'content_performance_manager_production',
  $db_password = undef,
  $db_username = 'content_performance_manager',
  $enable_procfile_worker = true,
  $etl_healthcheck_enabled = false,
  $etl_healthcheck_enabled_from_hour = undef,
  $google_analytics_govuk_view_id = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port = '3206',
  $publishing_api_bearer_token = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_vhost = '/',
  $rabbitmq_password = undef,
  $rabbitmq_user = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $support_api_bearer_token = undef,
) {
  $app_name = 'content-performance-manager'

  govuk::app { $app_name:
    app_type          => 'rack',
    port              => $port,
    sentry_dsn        => $sentry_dsn,
    health_check_path => '/healthcheck',
    json_health_check => true,
    asset_pipeline    => true,
    read_timeout      => 60,
  }

  Govuk::App::Envvar {
    app    => $app_name,
  }

  govuk::procfile::worker { "${app_name}-default-worker":
    enable_service => $enable_procfile_worker,
    setenv_as      => $app_name,
    process_type   => 'default-worker',
  }

  govuk::procfile::worker { "${app_name}-publishing-api-consumer":
    enable_service => $enable_procfile_worker,
    setenv_as      => $app_name,
    process_type   => 'publishing-api-consumer',
  }

  govuk::procfile::worker { 'cpm-bulk-import-publishing-api-consumer':
    enable_service => $enable_procfile_worker,
    setenv_as      => $app_name,
    process_type   => 'bulk-import-publishing-api-consumer',
  }

  govuk::app::envvar {
    "${title}-GOOGLE_ANALYTICS_GOVUK_VIEW_ID":
      varname => 'GOOGLE_ANALYTICS_GOVUK_VIEW_ID',
      value   => $google_analytics_govuk_view_id;
    "${title}-GOOGLE_PRIVATE_KEY":
      varname => 'GOOGLE_PRIVATE_KEY',
      value   => $google_private_key;
    "${title}-GOOGLE_CLIENT_EMAIL":
      varname => 'GOOGLE_CLIENT_EMAIL',
      value   => $google_client_email;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-RABBITMQ_HOSTS":
      varname => 'RABBITMQ_HOSTS',
      value   => join($rabbitmq_hosts, ',');
    "${title}-RABBITMQ_VHOST":
      varname => 'RABBITMQ_VHOST',
      value   => $rabbitmq_vhost;
    "${title}-RABBITMQ_USER":
      varname => 'RABBITMQ_USER',
      value   => $rabbitmq_user;
    "${title}-RABBITMQ_PASSWORD":
      varname => 'RABBITMQ_PASSWORD',
      value   => $rabbitmq_password;
    "${title}-SUPPORT_API_BEARER_TOKEN":
      varname => 'SUPPORT_API_BEARER_TOKEN',
      value   => $support_api_bearer_token;
  }

  if $etl_healthcheck_enabled {
    govuk::app::envvar {
      "${title}-ETL_HEALTHCHECK_ENABLED":
        varname => 'ETL_HEALTHCHECK_ENABLED',
        value   => '1';
      "${title}-ETL_HEALTHCHECK_ENABLED_FROM_HOUR":
        varname => 'ETL_HEALTHCHECK_ENABLED_FROM_HOUR',
        value   => $etl_healthcheck_enabled_from_hour;
    }
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'postgresql',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }
}
