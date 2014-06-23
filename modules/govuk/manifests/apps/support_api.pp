class govuk::apps::support_api(
  $port = 3075,
  $enabled = false
) {
  if $enabled {
    govuk::app { 'support-api':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}
