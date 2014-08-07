class govuk::apps::service_manual (
  $port = 3082,
  $enabled = false,
  $vhost_protected,
) {

  if $enabled {
    govuk::app { 'service-manual':
      app_type              => 'rack',
      port                  => $port,
      vhost_protected       => $vhost_protected,
      health_check_path     => '/',
    }
  }

}
