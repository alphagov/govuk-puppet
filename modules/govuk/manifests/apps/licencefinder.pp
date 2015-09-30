# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::licencefinder(
  $port = '3014',
) {
  govuk::app { 'licencefinder':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/licence-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'licencefinder',
  }
}
