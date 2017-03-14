# == Class: govuk::apps::collections
#
# Collections is an app to serve collection pages from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: collections
#
# [*port*]
#   What port should the app run on?
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::collections(
  $vhost = 'collections',
  $port = '3070',
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {
  govuk::app { 'collections':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/topic/oil-and-gas',
    log_format_is_json     => true,
    asset_pipeline         => true,
    asset_pipeline_prefix  => 'collections',
    vhost                  => $vhost,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  Govuk::App::Envvar {
    app => 'collections',
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
