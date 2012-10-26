class govuk::apps::panopticon( $port = 3003 ) {
  govuk::app { 'panopticon':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    },
  }
}
