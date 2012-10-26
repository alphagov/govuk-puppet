class govuk::apps::tariff_api($port = 3018) {
  govuk::app { 'tariff-api':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck',
  }
}
