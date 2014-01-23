class govuk::apps::tariff_api($port = 3018) {
  govuk::app { 'tariff-api':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/healthcheck',
    log_format_is_json     => true,
    #2.5GB for a warning
    nagios_memory_warning  => 2684354560,
  }

  govuk::procfile::worker {'tariff-api': }
}
