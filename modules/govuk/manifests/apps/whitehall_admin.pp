class govuk::apps::whitehall_admin( $port = 3026 ) {
  govuk::app { 'whitehall-admin':
    type => 'rails',
    port => $port;
  }
}
