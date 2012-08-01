class govuk::apps::planner( $port = 3007 ) {
  govuk::app { 'planner':
    app_type => 'rack',
    port     => $port;
  }
}
