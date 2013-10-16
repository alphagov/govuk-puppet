class govuk::apps::router (
  $port = 3054,
  $api_port = 3055,
  $mongodb_nodes
) {
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
  }

  govuk::app { 'router':
    app_type           => 'bare',
    command            => './router',
    port               => $port,
    enable_nginx_vhost => false,
    logstream          => true,
  }
}
