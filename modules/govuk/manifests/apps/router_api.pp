class govuk::apps::router_api( $port = 3056 ) {
  govuk::app { 'router-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  unless $::govuk_platform == 'development' {
    govuk::app::envvar {
      "${title}-ENABLE_ROUTER_RELOADING":
        app     => 'router-api',
        varname => 'ENABLE_ROUTER_RELOADING',
        value   => '1';
    }
  }
}
