class govuk::apps::whitehall_frontend( $port = 3020 ) {
  govuk::app { 'whitehall-frontend':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck';
  }
}
