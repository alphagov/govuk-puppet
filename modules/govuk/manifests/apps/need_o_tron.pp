class govuk::apps::need_o_tron($port = '3004') {
  govuk::app { 'needotron':
    app_type          => 'rack',
    vhost_ssl_only    => true,
    port              => $port,
    health_check_path => '/',
    intercept_errors  => str2bool(extlookup('needotron_intercept_errors', 'true')),
  }
}
