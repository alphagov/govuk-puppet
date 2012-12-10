class govuk::apps::travel_advice_publisher( $port = 3035 ) {
  govuk::app { 'travel-advice-publisher':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}
