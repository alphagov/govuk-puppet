class govuk::apps::limelight(
  $port = 3040,
  $vhost_protected
) {
  govuk::app { 'limelight':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected
  }
}

