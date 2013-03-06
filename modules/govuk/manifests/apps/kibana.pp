class govuk::apps::kibana( $port = 3202 ) {
  govuk::app { 'kibana':
    app_type  => 'rack',
    port      => $port,
    logstream => true,
  }
}
