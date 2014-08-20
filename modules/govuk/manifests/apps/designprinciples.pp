# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::designprinciples(
  $vhost_protected,
  $port = 3023
) {
  govuk::app { 'designprinciples':
    app_type              => 'rack',
    vhost_protected       => $vhost_protected,
    port                  => $port,
    health_check_path     => '/design-principles',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'designprinciples',
  }
}
