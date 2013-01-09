class govuk::apps::release( $port = 3036 ) {
  govuk::app { 'release':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    intercept_errors  => str2bool(extlookup('release_intercept_errors', 'yes')),
    vhost_protected   => false
  }
}
