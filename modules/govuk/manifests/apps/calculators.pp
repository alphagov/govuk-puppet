# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::calculators(
  $port = 3047,
  $vhost_protected
) {
  govuk::app { 'calculators':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/child-benefit-tax-calculator',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calculators',
  }
}
