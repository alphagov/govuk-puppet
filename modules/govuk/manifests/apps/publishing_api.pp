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
#   Default: 3093
#
# [*content_store*]
#   Is a URL that tells publishing API which content store to save
#   published content in.
#
# [*draft_content_store*]
#   Is a URL that tells publishing API which content store to save
#   draft content in.
#
# [*suppress_draft_store_502_error*]
#   Suppresses "502 Bad Gateway" returned by nginx when publishing API
#   attempts to store draft content. This is intended to be used only
#   during development so that we're not forced to keep draft content
#   store running while testing unrelated features.
#   Default: ''
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
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
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
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
  $port = '3093',
  $content_store = '',
  $draft_content_store = '',
  $suppress_draft_store_502_error = '',
  $errbit_api_key = '',
  $secret_key_base = undef,
  $db_hostname = undef,
  $db_username = 'publishing_api',
  $db_password = undef,
  $db_name = 'publishing_api_production',
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
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
    ensure            => $ensure,
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
    legacy_logging    => false,
    deny_framing      => true,
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

    govuk::app::envvar {
      "${title}-CONTENT_STORE":
        varname => 'CONTENT_STORE',
        value   => $content_store;
      "${title}-DRAFT_CONTENT_STORE":
        varname => 'DRAFT_CONTENT_STORE',
        value   => $draft_content_store;
      "${title}-SUPPRESS_DRAFT_STORE_502_ERROR":
        varname => 'SUPPRESS_DRAFT_STORE_502_ERROR',
        value   => $suppress_draft_store_502_error;
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-RABBITMQ_PASSWORD":
        varname => 'RABBITMQ_PASSWORD',
        value   => $rabbitmq_password;
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

    if $::govuk_node_class !~ /^(development|training)$/ {
      govuk::app::envvar::database_url { $app_name:
        type     => 'postgresql',
        username => $db_username,
        password => $db_password,
        host     => $db_hostname,
        database => $db_name,
      }
    }
  }

  govuk_logging::logstream { 'publishing_api_sidekiq_json_log':
    logfile => '/var/apps/publishing-api/log/sidekiq.json.log',
    fields  => {'application' => 'publishing-api-sidekiq'},
    json    => true,
  }

}
