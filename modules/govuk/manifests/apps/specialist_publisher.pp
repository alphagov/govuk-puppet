# == Class: govuk::apps::specialist_publisher
#
# Publishing App for specialist documents and finders.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3064
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: false
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*publish_pre_production_finders*]
#   Whether to enable publishing of pre-production finders
#   Default: false
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*aws_access_key_id*]
#   The Access Key ID for AWS to access S3 buckets.
#   Default: undef
#
# [*aws_secret_access_key*]
#   The Secret Access Key for AWS to access S3 buckets.
#   Default: undef
#
# [*aws_region*]
#   The Region for AWS to access S3 buckets.
#   Default: undef
#
# [*aws_s3_bucket_name*]
#   The S3 Bucket for AWS to access.
#   Default: undef
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*secret_key_base*]
#   The secret key base value for rails
#   Default: undef
#
class govuk::apps::specialist_publisher(
  $port = '3064',
  $asset_manager_bearer_token = undef,
  $sentry_dsn = undef,
  $enabled = false,
  $enable_procfile_worker = true,
  $mongodb_nodes,
  $mongodb_name,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publish_pre_production_finders = false,
  $publishing_api_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_s3_bucket_name = undef,
  $aws_region = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
) {

  $app_name = 'specialist-publisher'

  if $enabled {
    govuk::app { $app_name:
      app_type               => 'rack',
      port                   => $port,
      sentry_dsn             => $sentry_dsn,
      health_check_path      => '/healthcheck',
      json_health_check      => true,
      log_format_is_json     => true,
      nginx_extra_config     => '
client_max_body_size 500m;
',
      nagios_memory_warning  => $nagios_memory_warning,
      nagios_memory_critical => $nagios_memory_critical,
      asset_pipeline         => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    if $publish_pre_production_finders {
      govuk::app::envvar {
        "${title}-PUBLISH_PRE_PRODUCTION_FINDERS":
          varname => 'PUBLISH_PRE_PRODUCTION_FINDERS',
          value   => '1';
      }
    }

    govuk::procfile::worker { $app_name:
      enable_service => $enable_procfile_worker,
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
    }

    if $secret_key_base != undef {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base,
      }
    }
  }
}
