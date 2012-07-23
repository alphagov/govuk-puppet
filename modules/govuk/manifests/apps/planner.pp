class govuk::apps::planner( $port = 3007 ) {
  govuk::app { 'planner':
    port => $port;
  }
}
