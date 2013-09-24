class govuk::apps::need_api( $port = 3052 ) {
  govuk::app { 'need-api':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
  }
}
