class govuk::apps::business_support_api( $port = 3061 ) {
  govuk::app { 'business-support-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }
}
