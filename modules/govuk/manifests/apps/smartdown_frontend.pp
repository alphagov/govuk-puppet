class govuk::apps::smartdown_frontend(
  $port = 3077,
  $vhost_protected
) {
  govuk::app { 'smartdown-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/smartdown-healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'smartdown-frontend',
  }
}
