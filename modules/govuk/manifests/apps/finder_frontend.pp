class govuk::apps::finder_frontend(
  $port = 3062,
  $vhost_protected = false,
  $enabled = false,
) {

  if str2bool($enabled) {
    govuk::app { 'finder-frontend':
      app_type               => 'rack',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      health_check_path      => '/cma-cases',
      log_format_is_json     => true,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'finder-frontend',
    }
  }
}
