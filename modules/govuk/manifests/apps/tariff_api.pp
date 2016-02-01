# == Class: govuk::apps::tariff_api
#
# Configure the tariff-api application
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
class govuk::apps::tariff_api(
    $port = '3018',
    $enable_procfile_worker = true,
    $nagios_memory_warning = undef,
    $nagios_memory_critical = undef,
  ) {
  govuk::app { 'tariff-api':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/healthcheck',
    log_format_is_json     => true,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }
  govuk::procfile::worker {'tariff-api':
    enable_service => $enable_procfile_worker,
  }

  if $enable_procfile_worker {
    govuk::logstream { 'tariff-api-importer-log':
      logfile => '/var/apps/tariff-api/logs/tariff_importer.log',
      tags    => ['stdout', 'app', 'tariff-importer'],
      fields  => {'application' => 'tariff-api'},
    }

    govuk::logstream { 'tariff-api-synchronizer-log':
      logfile => '/var/apps/tariff-api/logs/tariff_synchronizer.log',
      tags    => ['stdout', 'app', 'tariff-synchronizer'],
      fields  => {'application' => 'tariff-api'},
    }
  }
}
