# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::tariff(
  $port = 3017,
) {
  govuk::app { 'tariff':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/trade-tariff/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'tariff',
  }
}
