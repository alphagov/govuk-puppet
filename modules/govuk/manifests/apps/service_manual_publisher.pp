class govuk::apps::service_manual_publisher(
  $port = 3111,
  $enabled = false,
) {

  if $enabled {
    govuk::app { 'service-manual-publisher':
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }
  }
}
