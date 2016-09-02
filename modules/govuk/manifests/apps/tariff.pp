# == Class: govuk::apps::tariff
#
# App details at: https://github.com/alphagov/trade-tariff-frontend
# FIXME: Remove this class when removed from all environments
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
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::tariff(
  $port = '3017',
  $publishing_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {
  govuk::app { 'tariff':
    ensure                 => 'absent',
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/trade-tariff/healthcheck',
    log_format_is_json     => true,
    asset_pipeline         => true,
    asset_pipeline_prefix  => 'tariff',
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

}
