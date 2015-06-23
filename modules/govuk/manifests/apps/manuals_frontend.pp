# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::manuals_frontend(
  $vhost,
  $port = 3072,
) {
  govuk::app { 'manuals-frontend':
    app_type              => 'rack',
    port                  => $port,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'manuals-frontend',
    vhost                 => $vhost,
  }
}
