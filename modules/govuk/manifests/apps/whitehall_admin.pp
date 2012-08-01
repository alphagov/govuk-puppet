class govuk::apps::whitehall_admin( $port = 3026 ) {
  govuk::app { 'whitehall-admin':
    app_type => 'rack',
    port     => $port;
  }
}
