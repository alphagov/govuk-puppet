class govuk::apps::maslow( $port = 3053 ) {
  govuk::app { 'maslow':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
  }
}
