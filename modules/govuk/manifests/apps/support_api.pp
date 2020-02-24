# == Class: govuk::apps::support_api
#
# The GOV.UK application for:
#
# - storing and persisting and querying anonymous feedback data
# - pushing requests into Zendesk when necessary
#
# === Parameters
#
# [*ensure*]
#   Whether Support API should be present or absent.
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
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
# [*db_password*]
#   The password for the database.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*enable_procfile_worker*]
#   Whether the Upstart-based background worker process is configured or not.
#   Default: true
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
# The Oauth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
# The Oauth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
#
# [*port*]
#   The port where the Rails app is running.
#   Default: 3075
#
# [*pp_data_bearer_token*]
#   Bearer token used to connect to Performance Platform.
#
# [*pp_data_url*]
#   Environment specific URL for the Performance Platform.
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
# [*zendesk_anonymous_ticket_email*]
#   Email address used for anonymous zendesk tickets.
#
# [*zendesk_client_password*]
#   Password for connection to GDS zendesk client.
#
# [*zendesk_client_username*]
#   Username for connection to GDS zendesk client.
#
# [*aws_access_key_id*]
#   The Access Key ID for AWS to access S3 buckets.
#
# [*aws_secret_access_key*]
#   The Secret Access Key for AWS to access S3 buckets.
#
# [*aws_region*]
#   The Region for AWS to access S3 buckets.
#
# [*aws_s3_bucket_name*]
#   The S3 Bucket for AWS to access.
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
class govuk::apps::support_api(
  $ensure = 'present',
  $db_hostname = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = undef,
  $db_password = undef,
  $db_username = undef,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port = '3075',
  $pp_data_url = undef,
  $pp_data_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $zendesk_anonymous_ticket_email = undef,
  $zendesk_client_password = undef,
  $zendesk_client_username = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $aws_s3_bucket_name = undef,
  $govuk_notify_api_key = undef,
) {
  $app_name = 'support-api'

  govuk::app { $app_name:
    ensure             => $ensure,
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  Govuk::App::Envvar {
    ensure => $ensure,
    app    => $app_name,
  }

  govuk::app::envvar {
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PP_DATA_BEARER_TOKEN":
      varname => 'PP_DATA_BEARER_TOKEN',
      value   => $pp_data_bearer_token;
    "${title}-PP_DATA_URL":
      varname => 'PP_DATA_URL',
      value   => $pp_data_url;
    "${title}-ZENDESK_ANONYMOUS_TICKET_EMAIL":
      varname => 'ZENDESK_ANONYMOUS_TICKET_EMAIL',
      value   => $zendesk_anonymous_ticket_email;
    "${title}-ZENDESK_CLIENT_PASSWORD":
      varname => 'ZENDESK_CLIENT_PASSWORD',
      value   => $zendesk_client_password;
    "${title}-ZENDESK_CLIENT_USERNAME":
      varname => 'ZENDESK_CLIENT_USERNAME',
      value   => $zendesk_client_username;
    "${title}-AWS_ACCESS_KEY_ID":
      varname => 'AWS_ACCESS_KEY_ID',
      value   => $aws_access_key_id;
    "${title}-AWS_SECRET_ACCESS_KEY":
      varname => 'AWS_SECRET_ACCESS_KEY',
      value   => $aws_secret_access_key;
    "${title}-AWS_REGION":
      varname => 'AWS_REGION',
      value   => $aws_region;
    "${title}-AWS_S3_BUCKET_NAME":
      varname => 'AWS_S3_BUCKET_NAME',
      value   => $aws_s3_bucket_name;
    "${title}-GOVUK_NOTIFY_API_KEY":
      varname => 'GOVUK_NOTIFY_API_KEY',
      value   => $govuk_notify_api_key;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
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

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem
}
