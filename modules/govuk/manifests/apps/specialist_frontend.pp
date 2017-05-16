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
# [*errbit_api_key*]
#   Errbit API key used by Airbrake
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
  $errbit_api_key = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  $app_name = 'specialist-frontend'

  if $enabled {
    govuk::app { $app_name:
      ensure                 => 'absent',
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

    Govuk::App::Envvar {
      ensure => 'absent',
      app    => $app_name,
    }

    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    }
  }
}
