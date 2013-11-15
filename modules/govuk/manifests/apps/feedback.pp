class govuk::apps::feedback(
  $port = 3028,
  $vhost_protected
) {
  govuk::app { 'feedback':
    app_type           => 'rack',
    port               => $port,
    log_format_is_json => true,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/contact',
  }
}
