class govuk::apps::businesssupportfinder(
  $port = 3024,
  $vhost_protected
) {
  govuk::app { 'businesssupportfinder':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/business-finance-support-finder',
  }
}
