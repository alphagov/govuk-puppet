# == Class: govuk::apps::finder_frontend
#
# Configure the finder-frontend application
#
# === Parameters
#
# FIXME: Document all parameters
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::finder_frontend(
  $port = '3062',
  $enabled = false,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {

  if $enabled {
    govuk::app { 'finder-frontend':
      app_type               => 'rack',
      port                   => $port,
      health_check_path      => '/cma-cases',
      log_format_is_json     => true,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'finder-frontend',
      nagios_memory_warning  => $nagios_memory_warning,
      nagios_memory_critical => $nagios_memory_critical,
    }
  }

  Govuk::App::Envvar {
    app => 'finder-frontend',
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }
}
