class govuk::apps::fact_cave(
  $port = 3048,
  $vhost_protected
) {
  govuk::app { 'fact-cave':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/',
  }
}
