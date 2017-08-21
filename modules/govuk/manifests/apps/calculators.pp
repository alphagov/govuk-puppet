# == Class: govuk::apps::calculators
#
# App details at: https://github.com/alphagov/calculators
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3047
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::calculators(
  $port = '3047',
  $publishing_api_bearer_token = undef,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'calculators':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/child-benefit-tax-calculator/main',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calculators',
  }

  Govuk::App::Envvar {
    app => 'calculators',
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }
}
