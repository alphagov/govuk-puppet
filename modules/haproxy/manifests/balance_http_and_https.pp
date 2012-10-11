define haproxy::balance_http_and_https (
    $servers,
    $http_listen_port,
    $https_listen_port,
    $health_check_port,
    $internal_only = false,
    $aliases=[],
    $health_check_method = 'HEAD') {
  haproxy::balance_http {$title:
    servers             => $servers,
    listen_port         => $http_listen_port,
    health_check_port   => $health_check_port,
    internal_only       => $internal_only,
    aliases             => $aliases,
    health_check_method => $health_check_method
  }
  haproxy::balance_https {$title:
    servers             => $servers,
    listen_port         => $https_listen_port,
    health_check_port   => $health_check_port,
    internal_only       => $internal_only,
    aliases             => $aliases,
    health_check_method => $health_check_method
  }
}
