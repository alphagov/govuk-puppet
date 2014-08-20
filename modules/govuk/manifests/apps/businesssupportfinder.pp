# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::businesssupportfinder(
  $port = 3024,
  $vhost_protected
) {
  govuk::app { 'businesssupportfinder':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/business-finance-support-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'businesssupportfinder',
  }
}
