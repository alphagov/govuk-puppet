class govuk::apps::errbit( $port = 3029 ) {
  govuk::app { 'errbit':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
  }
}
