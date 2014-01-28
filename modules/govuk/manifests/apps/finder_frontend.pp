class govuk::apps::finder_frontend(
  $port = 3062,
  $vhost_protected = false,
  $enabled = false,
) {

  if str2bool($enabled) {
    govuk::app { 'finder_frontend':
      app_type               => 'rack',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      health_check_path      => '/',
      log_format_is_json     => true,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'finder-frontend',
    }
  }
}
