class govuk::apps::tariff_api($port = 3018) {
  govuk::app { 'tariff-api':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/healthcheck',
    log_format_is_json => hiera('govuk_leverage_json_app_log', false),
  }
}
