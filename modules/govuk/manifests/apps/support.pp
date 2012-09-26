class govuk::apps::support($port = 3031) {
  govuk::app { 'support':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/';
  }
}