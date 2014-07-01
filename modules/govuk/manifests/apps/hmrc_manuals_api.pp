class govuk::apps::hmrc_manuals_api(
  $port = 3071,
  $enabled = false
) {
  if $enabled {
    govuk::app { 'hmrc-manuals-api':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}
