# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::collections(
  $port = 3070,
) {
  govuk::app { 'collections':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/topic/oil-and-gas',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'collections',
  }
}
