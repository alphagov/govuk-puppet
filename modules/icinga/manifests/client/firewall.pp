class icinga::client::firewall {
  @ufw::allow { 'allow-nrpe-from-all':
    port => 5666,
  }
}
