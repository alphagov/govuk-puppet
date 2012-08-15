class govuk::apps::need_o_tron($port = '4000') {
  govuk::app { 'need_o_tron':
    app_type => 'rack',
    port     => $port;
  }
}
