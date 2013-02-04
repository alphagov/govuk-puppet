class collectd::server::firewall {
  @ufw::allow { 'allow-collectd-from-all':
    port  => 25826,
    proto => 'udp',
  }
}
