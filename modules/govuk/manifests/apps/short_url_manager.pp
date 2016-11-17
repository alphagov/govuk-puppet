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
# [*mongodb_nodes_string*]
#   List of mongo hostnames and ports.
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
class govuk::apps::short_url_manager(
  $errbit_api_key = undef,
  $mongodb_nodes_string = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $port = '3076',
  $redis_host = undef,
  $redis_port = '6379',
) {

  $app_name = 'short-url-manager'

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
    "${title}-MONGODB_NODES":
      varname => 'MONGODB_NODES',
      value   => $mongodb_nodes_string;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'short-url-manager',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  govuk::app::envvar::redis { $app_name:
    host      => $redis_host,
    port      => $redis_port,
    namespace => $app_name,
  }
}
