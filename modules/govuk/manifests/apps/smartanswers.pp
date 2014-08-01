class govuk::apps::smartanswers(
  $port = 3010,
  $vhost_protected
) {
  govuk::app { 'smartanswers':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/calculate-your-maternity-pay',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'smartanswers',
  }
}
