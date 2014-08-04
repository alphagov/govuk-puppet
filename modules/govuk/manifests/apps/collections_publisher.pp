class govuk::apps::collections_publisher(
  $port = 3078,
) {

  govuk::app { 'collections-publisher':
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => true,
    health_check_path      => '/',
    log_format_is_json     => true,
    asset_pipeline         => true,
    deny_framing           => true,
  }

}
