# == Class: govuk::apps::content_data_admin
#
# Read more: https://github.com/alphagov/content_data_admin
#
# === Parameters
# [*port*]
#   What port should the app run on? Find the next free one in development-vm/Procfile
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
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
# [*db_name*]
#   The database name to use for the DATABASE_URL environment variable
#
# [*content_data_api_bearer_token*]
#   The bearer token to use when communicating with Content Data API.
#   Default: undef
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
# [*aws_access_key_id*]
#   The Access Key ID for AWS to access S3 buckets.
#
# [*aws_secret_access_key*]
#   The Secret Access Key for AWS to access S3 buckets.
#
# [*aws_region*]
#   The Region for AWS to access S3 buckets.
#
# [*aws_csv_export_bucket_name*]
#   The S3 Bucket used for csv exports.
#
class govuk::apps::content_data_admin (
  $port                         = '3230',
  $enabled                      = true,
  $secret_key_base              = undef,
  $sentry_dsn                   = undef,
  $oauth_id                     = undef,
  $oauth_secret                 = undef,
  $db_username                  = 'content_data_admin',
  $db_hostname                  = undef,
  $db_port                      = undef,
  $db_allow_prepared_statements = undef,
  $db_password                  = undef,
  $db_name                      = 'content_data_admin_production',
  $content_data_api_bearer_token = undef,
  $google_tag_manager_id = undef,
  $google_tag_manager_preview = undef,
  $google_tag_manager_auth = undef,
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $aws_csv_export_bucket_name = undef,
) {
  $app_name = 'content-data-admin'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure                          => $ensure,
    app_type                        => 'rack',
    port                            => $port,
    sentry_dsn                      => $sentry_dsn,
    vhost                           => 'content-data',
    vhost_ssl_only                  => true,
    health_check_path               => '/healthcheck', # must return HTTP 200 for an unauthenticated request
    deny_framing                    => true,
    asset_pipeline                  => true,
    read_timeout                    => 60,
    additional_check_contact_groups => ['slack-channel-data-informed'],
  }

  # Redirect for the old domain
  $app_domain = hiera('app_domain')
  nginx::config::vhost::redirect { "content-data-admin.${app_domain}":
    to => "https://content-data.${app_domain}/",
  }

  if defined(Concat['/etc/nginx/lb_healthchecks.conf']) {
    concat::fragment { "${app_name}_lb_healthcheck":
      target  => '/etc/nginx/lb_healthchecks.conf',
      content => "location /_healthcheck_${app_name} {\n  proxy_pass http://content-data-proxy/healthcheck;\n}\n",
    }
  }

  Govuk::App::Envvar {
    app            => $app_name,
    ensure         => $ensure,
    notify_service => $enabled,
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
    "${title}-CONTENT_DATA_API_BEARER_TOKEN":
      varname => 'CONTENT_DATA_API_BEARER_TOKEN',
      value   => $content_data_api_bearer_token;
    "${title}-GOOGLE_TAG_MANAGER_ID":
      varname => 'GOOGLE_TAG_MANAGER_ID',
      value   => $google_tag_manager_id;
    "${title}-GOOGLE_TAG_MANAGER_PREVIEW":
      varname => 'GOOGLE_TAG_MANAGER_PREVIEW',
      value   => $google_tag_manager_preview;
    "${title}-GOOGLE_TAG_MANAGER_AUTH":
      varname => 'GOOGLE_TAG_MANAGER_AUTH',
      value   => $google_tag_manager_auth;
    "${title}-AWS_ACCESS_KEY_ID":
      varname => 'AWS_ACCESS_KEY_ID',
      value   => $aws_access_key_id;
    "${title}-AWS_SECRET_ACCESS_KEY":
      varname => 'AWS_SECRET_ACCESS_KEY',
      value   => $aws_secret_access_key;
    "${title}-AWS_REGION":
      varname => 'AWS_REGION',
      value   => $aws_region;
    "${title}-AWS_CSV_EXPORT_BUCKET_NAME":
      varname => 'AWS_CSV_EXPORT_BUCKET_NAME',
      value   => $aws_csv_export_bucket_name;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type                      => 'postgresql',
      username                  => $db_username,
      password                  => $db_password,
      host                      => $db_hostname,
      port                      => $db_port,
      database                  => $db_name,
      allow_prepared_statements => $db_allow_prepared_statements,
    }
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
    setenv_as      => $app_name,
    process_regex  => 'sidekiq .* content-data ',
  }
}
