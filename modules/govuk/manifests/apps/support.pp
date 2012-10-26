class govuk::apps::support($port = 3031) {

  govuk::app { 'support':
    app_type                => 'rack',
    port                    => $port,
    vhost_ssl_only          => true,
    health_check_path       => '/',
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    };
  }
}
