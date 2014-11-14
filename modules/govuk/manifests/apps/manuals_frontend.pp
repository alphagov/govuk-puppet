# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::manuals_frontend(
  $port = 3072,
  $enabled = false,
) {
  if $enabled {
    govuk::app { 'manuals-frontend':
      app_type              => 'rack',
      port                  => $port,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'manuals-frontend',
    }

    govuk::app { 'hmrc-manuals-frontend':
      ensure   => absent,
      app_type => 'rack',
      port     => $port,
    }
  }
}
