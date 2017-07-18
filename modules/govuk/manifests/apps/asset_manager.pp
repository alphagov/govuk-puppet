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
# [*enable_delayed_job_worker*]
#   Whether or not to enable the background worker for Delayed Job.
#   Boolean value.
# [*errbit_api_key*]
#   Errbit API key used by airbrake
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
#
class govuk::apps::asset_manager(
  $enabled = true,
  $port = '3037',
  $enable_delayed_job_worker = true,
  $errbit_api_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $mongodb_nodes,
  $mongodb_name = 'govuk_assets_production',
  $aws_s3_bucket_name = undef,
  $aws_region = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
) {

  $app_name = 'asset-manager'

  if $enabled {
    include assets
    include clamav

    $app_domain = hiera('app_domain')

    govuk::app::envvar {
      "${title}-PRIVATE_ASSET_MANAGER_HOST":
        app     => 'asset-manager',
        varname => 'PRIVATE_ASSET_MANAGER_HOST',
        value   => "private-asset-manager.${app_domain}";
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      vhost_aliases      => ['private-asset-manager'],
      log_format_is_json => true,
      deny_framing       => true,
      depends_on_nfs     => true,
      nginx_extra_config => '
      client_max_body_size 500m;

      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /var/apps/asset-manager/uploads/assets/=/raw/;

      # /raw/(.*) is the path mapping sent from the rails application to
      # nginx and is immediately picked up. /raw/(.*) is not available
      # publicly as it is an internal path mapping.
      location ~ /raw/(.*) {
        internal;
        alias /var/apps/asset-manager/uploads/assets/$1;
      }',
    }

    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
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

    govuk::delayed_job::worker { 'asset-manager':
      enable_service => $enable_delayed_job_worker,
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
