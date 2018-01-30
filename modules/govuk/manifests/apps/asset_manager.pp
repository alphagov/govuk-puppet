# class: govuk::apps::asset_manager
#
# Asset Manager manages uploaded assets (images, PDFs, etc.) for
# various applications, as an API and an asset-serving mechanism.
#
# === Parameters
#
# [*port*]
#   The port that Asset Manager is served on.
#   Default: 3037
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
#   Sets the OAuth ID
# [*oauth_secret*]
#   Sets the OAuth Secret Key
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
# [*mongodb_name*]
#   The name of the MongoDB database to use
# [*aws_s3_bucket_name*]
#   The name of the AWS S3 bucket to use for storing/serving assets
# [*aws_region*]
#   AWS region of the S3 bucket
# [*aws_access_key_id*]
#   AWS access key for a user with permission to write to the S3 bucket
# [*aws_secret_access_key*]
#   AWS secret key for a user with permission to write to the S3 bucket
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::asset_manager(
  $enabled = true,
  $port = '3037',
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $mongodb_nodes,
  $mongodb_name = 'govuk_assets_production',
  $aws_s3_bucket_name = undef,
  $aws_region = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $redis_host = undef,
  $redis_port = undef
) {

  $app_name = 'asset-manager'

  if $enabled {
    include assets
    include clamav

    $app_domain = hiera('app_domain')

    govuk::app::envvar {
      "${title}-PRIVATE_ASSET_MANAGER_HOST":
        ensure  => 'absent',
        app     => 'asset-manager',
        varname => 'PRIVATE_ASSET_MANAGER_HOST',
        value   => "private-asset-manager.${app_domain}";
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    # The X-Frame-Options response header is set explicitly in the
    # relevant location blocks.
    $deny_framing = false

    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      sentry_dsn         => $sentry_dsn,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
      deny_framing       => $deny_framing,
      depends_on_nfs     => true,
      nginx_extra_config => template('govuk/asset_manager_extra_nginx_config.conf.erb'),
    }

    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    if $secret_key_base {
      govuk::app::envvar {
        "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      }
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    govuk::procfile::worker { $app_name:
      enable_service => $enable_procfile_worker,
    }

    govuk::app::envvar {
      "${title}-AWS_S3_BUCKET":
        varname => 'AWS_S3_BUCKET_NAME',
        value   => $aws_s3_bucket_name;
      "${title}-AWS_REGION":
        varname => 'AWS_REGION',
        value   => $aws_region;
      "${title}-AWS_ACCESS_KEY":
        varname => 'AWS_ACCESS_KEY',
        value   => $aws_access_key_id;
      "${title}-AWS_SECRET_KEY":
        varname => 'AWS_SECRET_KEY',
        value   => $aws_secret_access_key;
    }
  }
}
