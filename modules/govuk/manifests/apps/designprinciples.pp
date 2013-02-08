class govuk::apps::designprinciples(
  $vhost_protected = undef,
  $port = 3023
) {
  govuk::app { 'designprinciples':
    app_type          => 'rack',
    vhost_protected   => $vhost_protected,
    port              => $port,
    health_check_path => '/designprinciples',
  }
}
