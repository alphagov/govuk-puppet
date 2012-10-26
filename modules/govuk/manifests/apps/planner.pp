class govuk::apps::planner( $port = 3007 ) {
  govuk::app { 'planner':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/maternity',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
