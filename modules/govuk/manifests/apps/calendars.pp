class govuk::apps::calendars( $port = 3011 ) {
  govuk::app { 'calendars':
    app_type => 'rack',
    port     => $port;
  }
}
