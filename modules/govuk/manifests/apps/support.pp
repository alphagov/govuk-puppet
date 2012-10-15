class govuk::apps::support($port = 3031) {
  govuk::app { 'support':
    app_type           => 'rack',
    vhost_aliases      => ['internalsupport'],
    port               => $port,
    health_check_path  => '/';
    enable_nginx_vhost => false,
  }
  nginx::config::vhost::proxy { "support.$::govuk_platform.alphagov.co.uk":
        to                    => ["localhost:${port}"],
        protected             => true,
        ssl_only              => true,
        server_names          => ['support.*','internalsupport.*'],
        health_check_path     => $health_check_path,
        health_check_port     => $health_check_port,
  }
}
