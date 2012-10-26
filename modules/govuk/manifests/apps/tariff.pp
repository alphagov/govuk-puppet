class govuk::apps::tariff($port = 3017) {
  govuk::app { 'tariff':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/trade-tariff/healthcheck',
  }
}
