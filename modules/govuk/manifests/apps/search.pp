class govuk::apps::search( $port = 3009 ) {
  include aspell

  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/mainstream/search?q=search_healthcheck',
  }
}
