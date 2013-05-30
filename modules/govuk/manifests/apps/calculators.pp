class govuk::apps::calculators(
  $port = 3042,
  $vhost_protected
) {
  govuk::app { 'calculators':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/child-benefit-tax-calculator',
  }
}
