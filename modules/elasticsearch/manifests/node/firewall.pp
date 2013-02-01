define elasticsearch::node::firewall(
  $http_port
) {
  @ufw::allow { "allow-elasticsearch-http-${http_port}-from-all":
    port => $http_port,
  }
}
