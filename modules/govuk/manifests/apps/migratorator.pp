class govuk::apps::migratorator( $port = 3015 ) {
  govuk::app { 'migratorator':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}
