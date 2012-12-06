class govuk::apps::travel_advice_frontend( $port = 3034 ) {
  govuk::app { 'travel-advice-frontend':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/travel-advice',
  }
}
