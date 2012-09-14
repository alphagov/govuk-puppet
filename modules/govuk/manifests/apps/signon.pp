class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type       => 'rack',
    port           => $port,
    vhost_ssl_only => true,
    health_check_path => "/users/sign_in"
  }
}
