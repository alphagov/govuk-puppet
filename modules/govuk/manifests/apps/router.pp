class govuk::apps::router (
  $port = 3054,
  $api_port = 3055,
  $mongodb_nodes
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
      value   => '/var/log/router/errors.json.log';
    'ROUTER_HEADER_TIMEOUT':
      value   => '20s';
  }

  govuk::app { 'router':
    app_type           => 'bare',
    command            => './router',
    port               => $port,
    enable_nginx_vhost => false,
  }

  govuk::logstream { "${title}-error-json-log":
    logfile       => '/var/log/router/errors.json.log',
    tags          => ['error'],
    fields        => {'application' => $title},
    json          => true,
  }
}
