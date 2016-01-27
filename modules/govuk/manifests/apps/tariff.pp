# == Class: govuk::apps::tariff
#
# App details at: https://github.com/alphagov/trade-tariff-frontend
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3017
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::tariff(
  $port = '3017',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'tariff':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/trade-tariff/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'tariff',
    # The tariff frontend levels off at around 2.7G memory used.
    nagios_memory_warning => 2800000000,
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'tariff',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
