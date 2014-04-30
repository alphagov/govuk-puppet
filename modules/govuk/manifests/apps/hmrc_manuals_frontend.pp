class govuk::apps::hmrc_manuals_frontend(
  $port = 3072,
  $vhost_protected = false,
  $enabled = false,
) {
  if $enabled {
    govuk::app { 'hmrc-manuals-frontend':
      app_type               => 'rack',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'hmrc-manuals-frontend',
    }
  }
}
