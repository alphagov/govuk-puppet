class govuk::apps::transition( $port = 3044 ) {
  govuk::app { 'transition':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => hiera('govuk_leverage_json_app_log', false),
    vhost_protected    => false
  }
}
