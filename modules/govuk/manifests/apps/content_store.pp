class govuk::apps::content_store(
  $port = 3068
) {
  govuk::app { 'content-store':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    vhost_aliases      => ['publishing-api'],
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }
}
