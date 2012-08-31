class govuk::apps::efg( $port = 3019 ) {
  govuk::app { 'efg':
    app_type       => 'rack',
    port           => $port,
    vhost_ssl_only => true;
  }
}
