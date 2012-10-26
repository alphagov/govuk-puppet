class govuk::apps::migratorator( $port = 3015 ) {

  include govuk::htpasswd

  govuk::app { 'migratorator':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    },
    nginx_extra_config => '
      deny all;
      auth_basic            "Migratorator";
      auth_basic_user_file  /etc/govuk.htpasswd;
      satisfy any;
    ',
  }

}
