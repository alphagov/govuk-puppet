class govuk::apps::need_o_tron($port = '4000') {
  govuk::app { 'needotron':
    app_type       => 'rack',
    vhost_ssl_only => true,
    port           => $port;
  }
}
