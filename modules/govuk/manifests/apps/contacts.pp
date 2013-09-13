class govuk::apps::contacts($port = 3051) {
  govuk::app { 'contacts':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck',
  }
}
