class devdns::service {
  service { 'resolvconf':
    ensure => running
  }
  service { 'dnsmasq':
    ensure => running
  }
}
