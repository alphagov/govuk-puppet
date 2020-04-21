# == Class: govuk::apps::government_frontend
#
# Government Frontend is an app to serve content pages form the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'government-frontend'
#
# [*port*]
#   What port should the app run on?
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
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
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*cpu_warning*]
#   CPU usage percentage that alerts are sounded at
#   Default: undef
#
# [*cpu_critical*]
#   CPU usage percentage that alerts are sounded at
#
class govuk::apps::government_frontend(
  $vhost = 'government-frontend',
  $port = '3090',
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $unicorn_worker_processes = undef,
  $cpu_warning = 150,
  $cpu_critical = 200,
) {
  Govuk::App::Envvar {
    app => 'government-frontend',
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
  govuk::app { 'government-frontend':
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_ssl_only           => true,
    health_check_path        => '/healthcheck',
    asset_pipeline           => true,
    asset_pipeline_prefixes  => ['government-frontend'],
    vhost                    => $vhost,
    unicorn_worker_processes => $unicorn_worker_processes,
    cpu_warning              => $cpu_warning,
    cpu_critical             => $cpu_critical,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
  }
}
