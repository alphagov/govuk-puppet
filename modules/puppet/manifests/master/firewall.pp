class puppet::master::firewall {
  @ufw::allow { "allow-puppetmaster-from-all":
    port => 8140,
  }
}
