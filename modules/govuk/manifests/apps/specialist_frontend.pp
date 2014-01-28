class govuk::apps::specialist_frontend(
  $port = 3065,
  $vhost_protected = false,
  $enabled = false,
) {

  $app_domain = hiera('app_domain')

  if str2bool($enabled) {
    govuk::app { 'specialist_frontend':
      app_type               => 'rack',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      vhost_aliases          => ['private-specialist-frontend'],
      health_check_path      => '/',
      log_format_is_json     => true,
      asset_pipeline         => true,
      asset_pipeline_prefix  => 'specialist-frontend',
    }
  }
}
