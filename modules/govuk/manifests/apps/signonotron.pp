class govuk::apps::signonotron( $port = 3016 ) {
  govuk::app { 'signonotron':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => "/users/sign_in",
    vhost_aliases     => ['signon'],
  }
}
