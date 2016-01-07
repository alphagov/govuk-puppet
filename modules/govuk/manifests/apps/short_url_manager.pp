# == Class: govuk::apps::short_url_manager
#
# Publishing tool to request, approve and create short URL redirects.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::short_url_manager(
  $port = '3076',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'short-url-manager':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'short-url-manager',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
