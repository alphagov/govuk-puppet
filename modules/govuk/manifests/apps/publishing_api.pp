# == Class: govuk::apps::publishing_api
#
# An application to act as a central store for all publishing content
# on GOV.UK.
#
# === Parameters
#
# [*ensure*]
#   Allow govuk app to be removed.
#
# [*port*]
#   The port that publishing API is served on.
#
# [*content_store*]
#   Is a URL that tells publishing API which content store to save
#   published content in.
#
# [*content_store_bearer_token*]
#   The bearer token that will be used to authenticate with the content store
#
# [*draft_content_store*]
#   Is a URL that tells publishing API which content store to save
#   draft content in.
#
# [*draft_content_store_bearer_token*]
#   The bearer token that will be used to authenticate with the draft content
#   store
#
# [*router_api_bearer_token*]
#   The bearer token that will be used to authenticate with the Router API.
#
# [*suppress_draft_store_502_error*]
#   Suppresses "502 Bad Gateway" returned by nginx when publishing API
#   attempts to store draft content. This is intended to be used only
#   during development so that we're not forced to keep draft content
#   store running while testing unrelated features.
#   Default: ''
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
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
# [*db_name*]
#   The database name to use in the DATABASE_URL.
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
#   Enables the sidekiq background worker.
#   Default: true
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#
# [*rabbitmq_password*]
#   A password to connect to RabbitMQ:
#   https://github.com/alphagov/publishing-api/blob/master/config/rabbitmq.yml
#
# [*govuk_content_schemas_path*]
#   The path for generated govuk-content-schemas
#
# [*event_log_aws_bucketname*]
#   The S3 bucket used to store the event logs.
#
# [*event_log_aws_username*]
#   The AWS IAM username that grants access to the event_log_aws_bucketname
#
# [*event_log_aws_access_id*]
#  The access key that grants access to event_log_aws_bucketname for event_log_aws_username
#
# [*event_log_aws_secret_key*]
#  The secret key that grants access to event_log_aws_bucketname for event_log_aws_username
#
# [*content_api_prototype*]
#  Set to true if you want to enable the Content API prototypes within the app
#
class govuk::apps::publishing_api(
  $ensure = 'present',
  $port,
  $content_store = '',
  $content_store_bearer_token = undef,
  $draft_content_store = '',
  $draft_content_store_bearer_token = undef,
  $router_api_bearer_token = undef,
  $suppress_draft_store_502_error = '',
  $unicorn_worker_processes = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $db_hostname = undef,
  $db_username = 'publishing_api',
  $db_password = undef,
  $db_port = undef,
  $db_name = 'publishing_api_production',
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'publishing_api',
  $rabbitmq_password = undef,
  $govuk_content_schemas_path = '',
  $event_log_aws_bucketname = undef,
  $event_log_aws_username   = undef,
  $event_log_aws_access_id  = undef,
  $event_log_aws_secret_key = undef,
  $content_api_prototype = false,
) {
  $app_name = 'publishing-api'

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  govuk::app { $app_name:
    ensure                           => $ensure,
    app_type                         => 'rack',
    port                             => $port,
    sentry_dsn                       => $sentry_dsn,
    vhost_ssl_only                   => true,
    health_check_service_template    => 'govuk_urgent_priority',
    health_check_notification_period => '24x7',
    has_liveness_health_check        => true,
    has_readiness_health_check       => true,
    unicorn_worker_processes         => $unicorn_worker_processes,
    log_format_is_json               => true,
    deny_framing                     => true,
  }

  govuk::procfile::worker {'publishing-api':
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

    govuk::app::envvar::rabbitmq { $app_name:
      hosts    => $rabbitmq_hosts,
      user     => $rabbitmq_user,
      password => $rabbitmq_password,
    }

    govuk::app::envvar {
      "${title}-CONTENT_STORE":
        varname => 'CONTENT_STORE',
        value   => $content_store;
      "${title}-CONTENT_STORE_BEARER_TOKEN":
        varname => 'CONTENT_STORE_BEARER_TOKEN',
        value   => $content_store_bearer_token;
      "${title}-DRAFT_CONTENT_STORE":
        varname => 'DRAFT_CONTENT_STORE',
        value   => $draft_content_store;
      "${title}-DRAFT_CONTENT_STORE_BEARER_TOKEN":
        varname => 'DRAFT_CONTENT_STORE_BEARER_TOKEN',
        value   => $draft_content_store_bearer_token;
      "${title}-ROUTER_API_BEARER_TOKEN":
        varname => 'ROUTER_API_BEARER_TOKEN',
        value   => $router_api_bearer_token;
      "${title}-SUPPRESS_DRAFT_STORE_502_ERROR":
        varname => 'SUPPRESS_DRAFT_STORE_502_ERROR',
        value   => $suppress_draft_store_502_error;
      "${title}-GDS_SSO_OAUTH_ID":
        varname => 'GDS_SSO_OAUTH_ID',
        value   => $oauth_id;
      "${title}-GDS_SSO_OAUTH_SECRET":
        varname => 'GDS_SSO_OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-GOVUK_CONTENT_SCHEMAS_PATH":
        varname => 'GOVUK_CONTENT_SCHEMAS_PATH',
        value   => $govuk_content_schemas_path;
      "${title}-EVENT_LOG_AWS_BUCKETNAME":
        varname => 'EVENT_LOG_AWS_BUCKETNAME',
        value   => $event_log_aws_bucketname;
      "${title}-EVENT_LOG_AWS_USERNAME":
        varname => 'EVENT_LOG_AWS_USERNAME',
        value   => $event_log_aws_username;
      "${title}-EVENT_LOG_AWS_ACCESS_ID":
        varname => 'EVENT_LOG_AWS_ACCESS_ID',
        value   => $event_log_aws_access_id;
      "${title}-EVENT_LOG_AWS_SECRET_KEY":
        varname => 'EVENT_LOG_AWS_SECRET_KEY',
        value   => $event_log_aws_secret_key;
    }

    if $content_api_prototype {
      govuk::app::envvar { "${title}-CONTENT_API_PROTOTYPE":
        varname => 'CONTENT_API_PROTOTYPE',
        value   => 'yes',
      }
    }

    if $secret_key_base != undef {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base,
      }
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
}
