class govuk::apps::finder_api(
  $port = 3063,
  $vhost_protected = false,
  $enabled = false,
) {

  if str2bool($enabled) {
    govuk::app { 'finder_api':
      app_type               => 'rack',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      health_check_path      => '/',
      log_format_is_json     => true,
    }
  }
}
