class govuk::apps::publisher( $port = 3000 ) {
  govuk::app { 'publisher':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    intercept_errors  => str2bool(extlookup('publisher_intercept_errors', 'yes')),
  }
}
