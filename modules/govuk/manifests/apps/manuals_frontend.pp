class govuk::apps::manuals_frontend(
  $port = 3072,
  $vhost_protected = false,
  $enabled = false,
) {
  if $enabled {
    govuk::app { 'manuals-frontend':
      app_type              => 'rack',
      port                  => $port,
      vhost_protected       => $vhost_protected,
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
