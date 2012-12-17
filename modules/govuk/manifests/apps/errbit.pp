class govuk::apps::errbit( $port = 3029 ) {
  govuk::app { 'errbit':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/',
  }
}
