class govuk::apps::router (
  $port = 3054,
  $api_port = 3055,
  $api_healthcheck = '/healthcheck',
  $mongodb_nodes
) {
  @ufw::allow { 'allow-router-reload-from-all':
    port => $api_port,
  }

  Govuk::App::Envvar {
    app => 'router',
  }

  govuk::app::envvar {
    "${title}-ROUTER_PUBADDR":
      varname => 'ROUTER_PUBADDR',
      value   => "localhost:${port}";
    "${title}-ROUTER_APIADDR":
      varname => 'ROUTER_APIADDR',
      value   => ":${api_port}";
    "${title}-ROUTER_MONGO_URL":
      varname => 'ROUTER_MONGO_URL',
      value   => join($mongodb_nodes, ',');
    "${title}-ROUTER_ERROR_LOG":
      varname => 'ROUTER_ERROR_LOG',
      value   => '/var/log/router/errors.json.log';
    "${title}-ROUTER_HEADER_TIMEOUT":
      varname => 'ROUTER_HEADER_TIMEOUT',
      value   => '20s';
  }

  govuk::app { 'router':
    app_type           => 'bare',
    command            => './router',
    port               => $port,
    enable_nginx_vhost => false,
  }

  # We can't pass `health_check_path` to `govuk::app` because it has the
  # reverse proxy port, not the API port. Changing the port would lose us
  # TCP connection stats.
  @@nagios::check { "check_app_router_up_on_${::hostname}":
    check_command       => "check_nrpe!check_app_up!${api_port} ${api_healthcheck}",
    service_description => 'router app running',
    host_name           => $::fqdn,
  }

  govuk::logstream { "${title}-error-json-log":
    logfile       => '/var/log/router/errors.json.log',
    tags          => ['error'],
    fields        => {'application' => $title},
    json          => true,
  }
}
