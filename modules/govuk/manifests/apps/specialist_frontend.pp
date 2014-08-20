# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::specialist_frontend(
  $port = 3065,
  $vhost_protected = false,
  $enabled = false,
) {

  if str2bool($enabled) {
    govuk::app { 'specialist-frontend':
      app_type              => 'rack',
      port                  => $port,
      vhost_protected       => $vhost_protected,
      vhost_aliases         => ['private-specialist-frontend'],
      log_format_is_json    => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'specialist-frontend',
    }
  }
}
