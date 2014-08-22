# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::tariff_api(
    $port = 3018,
    $enable_procfile_worker = true
  ) {
  govuk::app { 'tariff-api':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    #2.5GB for a warning
    nagios_memory_warning => 2684354560,
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
