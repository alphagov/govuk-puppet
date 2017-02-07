# == Class: govuk::apps::info_frontend
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#   Default: 3085
#
# [*enabled*]
#   Whether the app should be present in a given environment.
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::info_frontend(
  $port = '3085',
  $enabled = false,
  $errbit_api_key = '',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'info-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_aliases         => ['info-frontend'],
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'info-frontend',
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'info-frontend',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-ERRBIT_API_KEY":
      app     => 'info-frontend',
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
  }
}
