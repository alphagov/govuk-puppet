class govuk::apps::tariff(
  $port = 3017,
  $vhost_protected
) {
  govuk::app { 'tariff':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/trade-tariff/healthcheck',
  }
}
