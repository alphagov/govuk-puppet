class govuk::apps::tariff_admin( $port = 3046 ) {
  govuk::app { 'trade-tariff-admin':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
    vhost_protected   => false
  }
}