class ganglia::client::firewall {
  @ufw::allow { "allow-gmond-8649-tcp-from-all":
    proto => 'tcp',
    port  => 8649,
  }
  @ufw::allow { "allow-gmond-8649-udp-from-all":
    proto => 'udp',
    port  => 8649,
  }
}
