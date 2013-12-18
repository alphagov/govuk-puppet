class govuk::apps::calendars(
  $port = 3011,
  $vhost_protected
) {
  govuk::app { 'calendars':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/bank-holidays',
    log_format_is_json    => hiera('govuk_leverage_json_app_log', false),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calendars',
  }
}
