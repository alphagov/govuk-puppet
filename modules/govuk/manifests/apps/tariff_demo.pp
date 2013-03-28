class govuk::apps::tariff_demo(
  $port = 3043,
  $vhost_protected
) {
  govuk::app { 'tariff_demo':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/trade-tariff/healthcheck',
  }
}
