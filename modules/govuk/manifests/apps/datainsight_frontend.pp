class govuk::apps::datainsight_frontend( $port = 3027 ) {
  govuk::app { 'datainsight-frontend':
    app_type => 'rack',
    port     => $port;
  }

  include govuk::phantomjs
}
