class govuk::apps::router_api( $port = 3056 ) {
  govuk::app { 'router-api':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
  }
}
