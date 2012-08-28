class govuk::apps::contentapi( $port = 3022 ) {
  govuk::app { 'contentapi':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/search.json',
    health_check_port => '4022';
  }
}