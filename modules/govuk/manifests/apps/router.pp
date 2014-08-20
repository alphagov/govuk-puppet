class govuk::apps::router (
  $port = 3054,
  $api_port = 3055,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/router/errors.json.log',
  $mongodb_nodes,

  # These are only overridden in the dev VM to allow www.dev.gov.uk to go through the router.
  $enable_nginx_vhost = false,
  $vhost_aliases = [],
) {
  @ufw::allow { 'allow-router-reload-from-all':
    port => $api_port,
  }

  Govuk::App::Envvar {
    app => 'router',
  }

  govuk::app::envvar {
    'ROUTER_PUBADDR':
      value   => "localhost:${port}";
    'ROUTER_APIADDR':
      value   => ":${api_port}";
    'ROUTER_MONGO_URL':
      value   => join($mongodb_nodes, ',');
    'ROUTER_ERROR_LOG':
      value   => $error_log;
    'ROUTER_BACKEND_HEADER_TIMEOUT':
      value   => '20s';
  }

  govuk::app { 'router':
    app_type           => 'bare',
    command            => './router',
    port               => $port,
    enable_nginx_vhost => $enable_nginx_vhost,
    vhost_aliases      => $vhost_aliases,
  }

  # We can't pass `health_check_path` to `govuk::app` because it has the
  # reverse proxy port, not the API port. Changing the port would lose us
  # TCP connection stats.
  @@icinga::check { "check_app_router_up_on_${::hostname}":
    check_command       => "check_nrpe!check_app_up!${api_port} ${api_healthcheck}",
    service_description => 'router app running',
    host_name           => $::fqdn,
  }

  govuk::logstream { 'router-error-json-log':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'router'},
    json    => true,
  }
}
