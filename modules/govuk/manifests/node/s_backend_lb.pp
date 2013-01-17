class govuk::node::s_backend_lb {
  include govuk::node::s_base

  include haproxy
  include loadbalancer::cron

  $backend_servers = ["backend-1", "backend-2", "backend-3"]

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
    'migratorator':
      servers           => $backend_servers,
      health_check_port => 9515,
      https_listen_port => 8415,
      http_listen_port  => 8515;
    'release':
      servers           => $backend_servers,
      health_check_port => 9536,
      https_listen_port => 8436,
      http_listen_port  => 8536;
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
      health_check_port => 9505,
      https_listen_port => 8405,
      http_listen_port  => 8505;
    'support':
      servers           => $backend_servers,
      health_check_port => 9531,
      https_listen_port => 8431,
      http_listen_port  => 8531;
    'canary-backend':
      servers             => $backend_servers,
      internal_only       => true,
      health_check_port   => 9701,
      health_check_method => 'GET',
      https_listen_port   => 8601,
      http_listen_port    => 8701;
  }

  $mapit_servers = ["mapit-server-1", "mapit-server-2",]

  haproxy::balance_http {'mapit':
    servers           => $mapit_servers,
    health_check_port => 80,
    listen_port       => 10191,
    internal_only     => true,
  }
}
