class govuk::apps::businesssupportfinder( $port = 3024 ) {
  govuk::app { 'businesssupportfinder':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/business-finance-support-finder',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
