class govuk::apps::content_planner($port = 3058) {
  govuk::app { 'content-planner':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck',
    deny_framing      => true,
  }
}
