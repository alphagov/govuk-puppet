class govuk::apps::tariff_web_app($port = 3030) {
  govuk::app { 'tariff_web_app':
    app_type => 'rack',
    port     => $port;
  }
}
