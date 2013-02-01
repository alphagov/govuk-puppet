class elasticsearch::node::firewall(
  $http_port
) {
  @ufw::allow { "allow-elasticsearch-from-all":
    port => $http_port,
  }
}
