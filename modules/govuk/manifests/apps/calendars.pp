class govuk::apps::calendars( $port = 3011 ) {
  govuk::app { 'calendars':
    app_type          => 'rack',
    port              => $port,
    health_check_path => "/bank-holidays",
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
