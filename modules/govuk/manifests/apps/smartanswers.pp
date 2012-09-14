class govuk::apps::smartanswers( $port = 3010 ) {
  govuk::app { 'smartanswers':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/becoming-a-driving-instructor';
  }
}
