# == Class: govuk::apps::travel_advice_publisher
#
# App to publish travel advice.
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
class govuk::apps::travel_advice_publisher(
  $port = '3035',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'travel-advice-publisher':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'travel-advice-publisher',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
