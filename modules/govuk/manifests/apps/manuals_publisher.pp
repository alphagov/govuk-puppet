# == Class: govuk::apps::manuals_publisher
#
# Publishing App for manuals.
#
# === Parameters
#
# [*port*]
#   The port that Manuals Publisher is served on.
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'manuals_publisher_development'.
#
# [*mongodb_username*]
#   The username to use when logging to the MongoDB database,
#   only needed if the app uses documentdb rather than mongodb
#
# [*mongodb_password*]
#   The password to use when logging to the MongoDB database
#   only needed if the app uses documentdb rather than mongodb
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
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
# [*link_checker_api_secret_token*]
#   The Link Checker API secret token.
#   Default: undef
#
# [*link_checker_api_bearer_token*]
#   The bearer token that will be used to authenticate with link-checker-api
#   Default: undef
#
class govuk::apps::manuals_publisher(
  $port,
  $asset_manager_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $mongodb_nodes,
  $mongodb_name,
  $mongodb_username = '',
  $mongodb_password = '',
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $link_checker_api_secret_token = undef,
  $link_checker_api_bearer_token = undef,
) {
  $app_name = 'manuals-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    nginx_extra_config => 'client_max_body_size 500m;',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::procfile::worker {'manuals-publisher':
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
    username => $mongodb_username,
    password => $mongodb_password,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-ASSET_MANAGER_BEARER_TOKEN":
      varname => 'ASSET_MANAGER_BEARER_TOKEN',
      value   => $asset_manager_bearer_token;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
      varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
      value   => $email_alert_api_bearer_token;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-LINK_CHECKER_API_SECRET_TOKEN":
      varname => 'LINK_CHECKER_API_SECRET_TOKEN',
      value   => $link_checker_api_secret_token;
    "${title}-LINK_CHECKER_API_BEARER_TOKEN":
        varname => 'LINK_CHECKER_API_BEARER_TOKEN',
        value   => $link_checker_api_bearer_token;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
