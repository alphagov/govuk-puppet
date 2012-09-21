class govuk::apps::private_frontend( $port = 3030 ) {
  govuk::app { 'private-frontend':
    app_type          => 'rack',
    port              => $port,
    vhost             => 'www',
    health_check_path => '/'
  }
}
