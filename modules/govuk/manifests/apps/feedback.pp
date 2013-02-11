class govuk::apps::feedback(
  $port = 3028,
  $vhost_protected
) {
  govuk::app { 'feedback':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/feedback',
  }
}
