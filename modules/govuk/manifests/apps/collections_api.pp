class govuk::apps::collections_api(
  $port = 3084,
  $enabled = false,
) {

  govuk::app { 'collections-api':
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => true,
    health_check_path      => '/',
    log_format_is_json     => true,
    deny_framing           => true,
  }

}
