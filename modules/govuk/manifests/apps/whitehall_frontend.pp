class govuk::apps::whitehall_frontend( $port = 3020 ) {
  govuk::app { 'whitehall-frontend':
    port => $port;
  }
}
