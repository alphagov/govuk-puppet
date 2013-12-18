class govuk::apps::smartanswers(
  $port = 3010,
  $vhost_protected
) {
  govuk::app { 'smartanswers':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/become-a-driving-instructor',
    log_format_is_json    => hiera('govuk_leverage_json_app_log', false),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'smartanswers',
  }
}
