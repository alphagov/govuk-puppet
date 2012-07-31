class govuk::apps::whitehall_search( $port = 3025 ) {
  govuk::app { 'whitehall-search':
    app_type => 'rails',
    port     => $port;
  }
}
