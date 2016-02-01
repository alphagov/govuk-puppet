# == Class: govuk::apps::spotlight
#
# Spotlight is a frontend application for the Performance Platform.
#
# === Parameters
#
# [*alert_5xx_warning_rate*]
#   The 5xx error percentage that should generate a warning
#
# [*alert_5xx_critical_rate*]
#   The 5xx error percentage that should generate a critical
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?

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
class govuk::apps::spotlight (
  $alert_5xx_warning_rate,
  $alert_5xx_critical_rate,
  $enabled = false,
  $port = '3057',
  $publishing_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  if $enabled {
    govuk::app { 'spotlight':
      alert_5xx_warning_rate  => $alert_5xx_warning_rate,
      alert_5xx_critical_rate => $alert_5xx_critical_rate,
      app_type                => 'bare',
      command                 => '/usr/bin/node app/server',
      port                    => $port,
      vhost_ssl_only          => true,
      health_check_path       => '/_status',
      log_format_is_json      => true,
      nagios_memory_warning   => $nagios_memory_warning,
      nagios_memory_critical  => $nagios_memory_critical,
    }

    govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'spotlight',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token,
    }
  }
}
