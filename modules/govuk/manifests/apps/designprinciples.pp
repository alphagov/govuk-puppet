class govuk::apps::designprinciples( $port = 3023 ) {
  govuk::app { 'designprinciples':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/designprinciples';
  }
}
