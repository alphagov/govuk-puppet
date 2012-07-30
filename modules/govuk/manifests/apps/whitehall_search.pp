class govuk::apps::whitehall_search( $port = 3025 ) {
  govuk::app { 'whitehall-search':
    port => $port;
  }
}
