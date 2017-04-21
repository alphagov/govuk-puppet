# == Class govuk::apps::design-principles
#
# Design Principles for the Government Digital Service.
#
# === Parameters
#
# [*port*]
#   The port the app is served on.
#   Default: 3023
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::designprinciples(
  $port = '3023',
  $publishing_api_bearer_token = undef,
) {
  govuk::app { 'designprinciples':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/design-principles',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'designprinciples',
    repo_name             => 'design-principles',
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'designprinciples',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
