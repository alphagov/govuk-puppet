class govuk::apps::search( $port = 3009 ) {
  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/mainstream/search?q=search_healthcheck',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
