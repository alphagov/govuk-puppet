class govuk::apps::designprinciples(
  $vhost_protected,
  $port = 3023
) {
  govuk::app { 'designprinciples':
    app_type              => 'rack',
    vhost_protected       => $vhost_protected,
    port                  => $port,
    health_check_path     => '/design-principles',
    log_format_is_json    => hiera('govuk_leverage_json_app_log', false),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'designprinciples',
  }
}
