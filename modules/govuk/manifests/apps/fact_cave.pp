class govuk::apps::fact_cave( $port = 3048 ) {
  govuk::app { 'fact-cave':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}
