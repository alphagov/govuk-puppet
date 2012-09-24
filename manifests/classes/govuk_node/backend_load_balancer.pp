class govuk_node::backend_load_balancer {
  include govuk_node::base

  include haproxy

  $backend_servers = {
    "backend-1" => "10.3.0.2",
    "backend-2" => "10.3.0.3",
    "backend-3" => "10.3.0.4",
  }

  haproxy::balance_http_and_https {
    'signon':
      servers           => $backend_servers,
      health_check_port => 9516,
      https_listen_port => 8416,
      http_listen_port  => 8516;
    'panopticon':
      servers           => $backend_servers,
      health_check_port => 9503,
      https_listen_port => 8403,
      http_listen_port  => 8503;
    'contentapi':
      servers           => $backend_servers,
      health_check_port => 9522,
      https_listen_port => 8422,
      http_listen_port  => 8522,
      internal_only     => true;
  }

  $mapit_servers = {
    "mapit-server-1" => "10.3.0.9",
    "mapit-server-2" => "10.3.0.10",
  }

  haproxy::balance_http {'mapit':
    servers           => $mapit_servers,
    health_check_port => 80,
    listen_port       => 10191,
    internal_only     => true,
  }

}
