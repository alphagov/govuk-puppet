class govuk::apps::tariff_demo(
  $port = 3044,
  $vhost_protected
) {
  govuk::app { 'tariff-demo':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/trade-tariff/healthcheck',
  }
}
