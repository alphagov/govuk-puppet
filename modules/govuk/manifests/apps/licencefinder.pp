class govuk::apps::licencefinder(
  $port = 3014,
  $vhost_protected
) {
  govuk::app { 'licencefinder':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/licence-finder',
    log_format_is_json    => hiera('govuk_leverage_json_app_log', false),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'licencefinder',
  }
}
