class govuk::apps::panopticon( $port = 3003 ) {
  govuk::app { 'panopticon':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    intercept_errors  => str2bool(extlookup('panopticon_intercept_errors', 'true')),
  }
}
