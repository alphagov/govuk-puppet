# == Class: govuk::apps::metadata_api
#
# HTTP application that acts as an easy way to get metadata about given URLs on GOV.UK.
#
# === Parameters
#
# [*content_api_bearer_token*]
#   The bearer token to use when communicating with the content API.
#   Default: undef
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: false
#
# [*need_api_bearer_token*]
#   The bearer token to use when communicating with the need API.
#   Default: undef
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3064
#
class govuk::apps::metadata_api (
  $content_api_bearer_token = undef,
  $enabled = false,
  $need_api_bearer_token = undef,
  $port = '3087',
) {
  $app_name = 'metadata-api'

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    'HTTP_PORT': value => $port;
    "${title}-CONTENT_API_BEARER_TOKEN":
    varname => 'CONTENT_API_BEARER_TOKEN',
    value   => $content_api_bearer_token;
    "${title}-NEED_API_BEARER_TOKEN":
    varname => 'NEED_API_BEARER_TOKEN',
    value   => $need_api_bearer_token;
  }

  govuk::app { $app_name:
    app_type           => 'bare',
    log_format_is_json => true,
    port               => $port,
    command            => "./${app_name}",
    health_check_path  => '/healthcheck',
  }
}
