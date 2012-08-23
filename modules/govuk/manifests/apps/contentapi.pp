class govuk::apps::contentapi( $port = 3022 ) {
  govuk::app { 'contentapi':
    app_type => 'rack',
    port     => $port;
  }
}