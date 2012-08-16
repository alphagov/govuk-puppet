class govuk::apps::support($port = 4040) {
  govuk::app { 'support':
    app_type => 'rack',
    port     => $port;
  }
}