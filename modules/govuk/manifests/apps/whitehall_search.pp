class govuk::apps::whitehall_search( $port = 3025 ) {
  govuk::app { 'whitehall-search':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/government/search';
  }
}
