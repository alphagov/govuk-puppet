class govuk::apps::imminence( $port = 3002 ) {
  govuk::app { 'imminence':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    intercept_errors  => str2bool(extlookup('imminence_intercept_errors', 'true')),
  }
}
