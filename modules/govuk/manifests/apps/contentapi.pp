# == Class: govuk::apps::contentapi
#
# Configure the contentapi application - https://github.com/alphagov/govuk_content_api
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#   Default: 3022
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
class govuk::apps::contentapi (
  $port = '3022',
  $publishing_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  govuk::app { 'contentapi':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/vat-rates.json',
    log_format_is_json     => true,
    nginx_extra_config     => 'proxy_set_header API-PREFIX $http_api_prefix;',
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => 'contentapi',
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }
}
