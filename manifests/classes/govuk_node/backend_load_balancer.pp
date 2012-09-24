class govuk_node::backend_load_balancer {
  include govuk_node::base

  include haproxy

  $backend_servers = {
    "backend-1" => "10.3.0.2",
    "backend-2" => "10.3.0.3",
    "backend-3" => "10.3.0.4",
  }

  $mapit_servers = {
    "mapit-server-1" => "10.3.0.9",
    "mapit-server-2" => "10.3.0.10",
  }

  # Signon Load Balancers
  haproxy::balance_https {'signon':
    servers           => $backend_servers,
    health_check_port => 9516,
    listen_port       => 8416,
  }
  haproxy::balance_http {'signon':
    servers           => $backend_servers,
    health_check_port => 9516,
    listen_port       => 8516,
  }
  # Panopticon Load Balancers
  haproxy::balance_https {'panopticon':
    servers           => $backend_servers,
    health_check_port => 9503,
    listen_port       => 8403,
  }
  haproxy::balance_http {'panopticon':
    servers           => $backend_servers,
    health_check_port => 9503,
    listen_port       => 8503,
  }
  # Content API Load Balancers
  haproxy::balance_https {'contentapi':
    servers           => $backend_servers,
    health_check_port => 9522,
    listen_port       => 8422,
    internal_only     => true,
  }
  haproxy::balance_http {'contentapi':
    servers           => $backend_servers,
    health_check_port => 9522,
    listen_port       => 8522,
    internal_only     => true,
  }

  # Mapit Server Load Balancer
  haproxy::balance_http {'mapit':
    servers           => $mapit_servers,
    health_check_port => 80,
    listen_port       => 80,
    internal_only     => true,
  }

}
