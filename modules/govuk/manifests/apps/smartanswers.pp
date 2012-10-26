class govuk::apps::smartanswers( $port = 3010 ) {
  govuk::app { 'smartanswers':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/become-a-driving-instructor',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
