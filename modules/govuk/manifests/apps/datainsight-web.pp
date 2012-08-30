class govuk::apps::datainsight-web( $port = 3027 ) {
  govuk::app { 'datainsight-web':
    app_type => 'rack',
    port     => $port;
  }
}

