class govuk::apps::errbit( $port = 3034 ) {
  govuk::app { 'errbit':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
