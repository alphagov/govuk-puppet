class govuk::apps::migratorator( $port = 3015 ) {

  include govuk::htpasswd

  govuk::app { 'migratorator':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    vhost_protected   => true,
  }

}
