class govuk::apps::bouncer(
  $port = 3049,
  $vhost_protected = false
) {

  govuk::app { 'bouncer':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => false,
    health_check_path => '/',
    vhost_protected   => false
  }
}
