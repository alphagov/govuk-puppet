class govuk::apps::feedback( $port = 3028 ) {
  govuk::app { 'feedback':
    app_type => 'rack',
    port     => $port;
  }
}
