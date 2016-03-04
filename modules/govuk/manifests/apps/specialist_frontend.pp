# == Class: govuk::apps::specialist_frontend
#
# Specialist Frontend is an app to serve specialist documents created by the
# specialist publisher app and published to content-api.
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: specialist-frontend
#
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Whether the app is enabled in this environment.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::specialist_frontend(
  $vhost = 'specialist-frontend',
  $port = '3065',
  $enabled = false,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  if $enabled {
    govuk::app { 'specialist-frontend':
      app_type               => 'rack',
      port                   => $port,
      vhost_aliases          => ['private-specialist-frontend'],
      log_format_is_json     => true,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'specialist-frontend',
      vhost                  => $vhost,
      nagios_memory_warning  => $nagios_memory_warning,
      nagios_memory_critical => $nagios_memory_critical,
    }
  }
}
