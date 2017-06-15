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
class govuk::apps::calculators(
  $port = '3047',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'calculators':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/child-benefit-tax-calculator/main',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calculators',
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'calculators',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
