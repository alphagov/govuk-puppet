class govuk::apps::tariff_api(
    $port = 3018,
    $enable_procfile_worker = true
  ) {
  govuk::app { 'tariff-api':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/healthcheck',
    log_format_is_json     => true,
    #2.5GB for a warning
    nagios_memory_warning  => 2684354560,
  }
  # This feature flag can go when Procfile worker is deployed everywhere
  if str2bool($enable_procfile_worker) {
    govuk::procfile::worker {'tariff-api': }
  }
}
