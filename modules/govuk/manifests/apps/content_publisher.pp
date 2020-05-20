# == Class: govuk::apps::content-publisher
#
# Read more: https://github.com/alphagov/content-publisher
#
# === Parameters
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Whether to install the app. Don't change the default (false) until production-ready
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions (in govuk-secrets)
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions (in govuk-secrets)
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
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
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
# [*jwt_auth_secret*]
#   The secret used to encode JWT authentication tokens. This value needs to be
#   shared with authenticating-proxy which decodes the tokens.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*whitehall_bearer_token*]
#   The bearer token to use when communicating with Whitehall.
#   Default: undef
#
# [*aws_access_key_id*]
#   An access key that can be use with Amazon Web Services
#
# [*aws_secret_access_key*]
#   The secret key that corresponds with the aws_access_key_id
#
# [*aws_region*]
#   The AWS region which is used for AWS Services
#   default: eu-west-1
#
# [*aws_s3_activestorage_bucket*]
#   An S3 bucket in the specified AWS region
#
# [*google_tag_manager_id*]
#   The ID for the Google Tag Manager account
#
# [*google_tag_manager_preview*]
#   Allows a tag to be previewed in the Google Tag Manager interface
#
# [*google_tag_manager_auth*]
#   The identifier of an environment for Google Tag Manager
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
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
# [*govuk_notify_api_key*]
#   API key for integration with GOV.UK Notify for sending emails
#
# [*govuk_notify_template_id*]
#   Template ID for GOV.UK Notify
#
# [*email_address_override*]
#   An email address that intercepted Notify emails can be sent to
#
class govuk::apps::content_publisher (
  $port,
  $enabled = true,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $db_username = 'content_publisher',
  $db_hostname = undef,
  $db_password = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'content_publisher_production',
  $publishing_api_bearer_token = undef,
  $whitehall_bearer_token = undef,
  $jwt_auth_secret = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $aws_s3_bucket = undef,
  $google_tag_manager_id = undef,
  $google_tag_manager_preview = undef,
  $google_tag_manager_auth = undef,
  $asset_manager_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
  $email_address_override = undef,
) {
  $app_name = 'content-publisher'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure             => $ensure,
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck', # must return HTTP 200 for an unauthenticated request
    json_health_check  => true,
    deny_framing       => true,
    asset_pipeline     => true,
    nginx_extra_config => 'client_max_body_size 500m;',
  }

  Govuk::App::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-WHITEHALL_BEARER_TOKEN":
      varname => 'WHITEHALL_BEARER_TOKEN',
      value   => $whitehall_bearer_token;
    "${title}-JWT_AUTH_SECRET":
      varname => 'JWT_AUTH_SECRET',
      value   => $jwt_auth_secret;
    "${title}-AWS_ACCESS_KEY_ID":
        varname => 'AWS_ACCESS_KEY_ID',
        value   => $aws_access_key_id;
    "${title}-AWS_SECRET_ACCESS_KEY":
        varname => 'AWS_SECRET_ACCESS_KEY',
        value   => $aws_secret_access_key;
    "${title}-AWS_REGION":
        varname => 'AWS_REGION',
        value   => $aws_region;
    "${title}-AWS_S3_BUCKET":
        varname => 'AWS_S3_BUCKET',
        value   => $aws_s3_bucket;
    "${title}-GOOGLE_TAG_MANAGER_ID":
        varname => 'GOOGLE_TAG_MANAGER_ID',
        value   => $google_tag_manager_id;
    "${title}-GOOGLE_TAG_MANAGER_PREVIEW":
        varname => 'GOOGLE_TAG_MANAGER_PREVIEW',
        value   => $google_tag_manager_preview;
    "${title}-GOOGLE_TAG_MANAGER_AUTH":
        varname => 'GOOGLE_TAG_MANAGER_AUTH',
        value   => $google_tag_manager_auth;
    "${title}-ASSET_MANAGER_BEARER_TOKEN":
        varname => 'ASSET_MANAGER_BEARER_TOKEN',
        value   => $asset_manager_bearer_token;
    "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
    "${title}-EMAIL_ADDRESS_OVERRIDE":
        varname => 'EMAIL_ADDRESS_OVERRIDE',
        value   => $email_address_override;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
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

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }
}
