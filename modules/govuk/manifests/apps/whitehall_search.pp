class govuk::apps::whitehall_search( $port = 3025 ) {
  govuk::app { 'whitehall-search':
    type => 'rails',
    port => $port;
  }
}
