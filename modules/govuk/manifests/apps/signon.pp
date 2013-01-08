class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => "/users/sign_in",
    vhost_aliases     => ['signonotron'],
    vhost_protected   => false,
    intercept_errors  => str2bool(extlookup('signon_intercept_errors', true)),
  }
}
