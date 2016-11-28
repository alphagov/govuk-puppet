# == Class: govuk::apps::short_url_manager
#
# Publishing tool to request, approve and create short URL redirects.
#
# === Parameters
#
# [*errbit_api_key*]
#   Errbit API key for sending errors.
#   Default: undef
#
# [*mongodb_name*]
#   The mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
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
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
class govuk::apps::short_url_manager(
  $errbit_api_key = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $port = '3076',
  $redis_host = undef,
  $redis_port = '6379',
  $secret_key_base = undef,
) {

  $app_name = 'short-url-manager'

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
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
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
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
}
