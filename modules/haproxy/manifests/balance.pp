define haproxy::balance ($servers, $listen_port, $health_check_port) {
  concat::fragment {"haproxy_listen_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment.erb'),
    order   => 10,
  }
}
