class govuk::apps::calendars(
  $port = 3011,
  $vhost_protected = undef
) {
  govuk::app { 'calendars':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => "/bank-holidays",
  }
}
