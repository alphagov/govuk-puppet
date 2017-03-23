# == Class: govuk::apps::businesssupportfinder
#
# App details at: https://github.com/alphagov/business-support-finder
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3024
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::businesssupportfinder(
  $port = '3024',
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
) {
  $app_name = 'businesssupportfinder'

  govuk::app { $app_name:
    ensure                => 'absent',
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/business-finance-support-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'businesssupportfinder',
  }
}
