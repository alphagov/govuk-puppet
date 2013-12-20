class govuk::apps::panopticon( $port = 3003 ) {
  govuk::app { 'panopticon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => hiera('govuk_leverage_json_app_log', false),
    asset_pipeline     => true,
  }
}
