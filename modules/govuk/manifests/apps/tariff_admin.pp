class govuk::apps::tariff_admin($port = 3046) {
  govuk::app { 'tariff-admin':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/',
    log_format_is_json => true,
  }
}
