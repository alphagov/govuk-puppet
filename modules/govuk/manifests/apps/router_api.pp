# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::router_api( $port = 3056, $enable_router_reloading = true ) {
  govuk::app { 'router-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  validate_bool($enable_router_reloading)

  if ($enable_router_reloading) {
    govuk::app::envvar {
      "${title}-ENABLE_ROUTER_RELOADING":
        app     => 'router-api',
        varname => 'ENABLE_ROUTER_RELOADING',
        value   => '1';
    }
  }
}
