class govuk::apps::feedback( $port = 3028 ) {
  govuk::app { 'feedback':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/feedback';
  }
}
