class govuk_node::backend_load_balancer {
  include govuk_node::base

  include haproxy
  include loadbalancer::cron

  $backend_servers = {
    "backend-1" => "10.3.0.2",
    "backend-2" => "10.3.0.3",
    "backend-3" => "10.3.0.4",
  }

  haproxy::balance_http_and_https {
    'publisher':
      servers           => $backend_servers,
      health_check_port => 9500,
      https_listen_port => 8400,
      http_listen_port  => 8500;
    'imminence':
      servers           => $backend_servers,
      health_check_port => 9502,
      https_listen_port => 8402,
      http_listen_port  => 8502;
    'panopticon':
      servers           => $backend_servers,
      health_check_port => 9503,
      https_listen_port => 8403,
      http_listen_port  => 8503;
    'needotron':
      servers           => $backend_servers,
      health_check_port => 9504,
      https_listen_port => 8404,
      http_listen_port  => 8504;
    'signon':
      servers           => $backend_servers,
      health_check_port => 9516,
      https_listen_port => 8416,
      http_listen_port  => 8516;
    'tariff-api':
      servers           => $backend_servers,
      health_check_port => 9518,
      https_listen_port => 8418,
      http_listen_port  => 8518,
      internal_only     => true;
    'contentapi':
      servers           => $backend_servers,
      health_check_port => 9522,
      https_listen_port => 8422,
      http_listen_port  => 8522,
      internal_only     => true;
    'whitehall-admin':
      servers           => $backend_servers,
      health_check_port => 9526,
      https_listen_port => 8426,
      http_listen_port  => 8526;
    'search':
      internal_only     => true,
      servers           => $backend_servers,
      health_check_port => 9509,
      https_listen_port => 8409,
      http_listen_port  => 8509;
    'private-frontend':
      servers           => $backend_servers,
      health_check_port => 9530,
      https_listen_port => 8430,
      http_listen_port  => 8530;
  }
  if ($::govuk_platform == 'preview') {
    haproxy::balance_http_and_https {
      'support':
        servers           => $backend_servers,
        health_check_port => 9531,
        https_listen_port => 8431,
        http_listen_port  => 8531;
    }
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
