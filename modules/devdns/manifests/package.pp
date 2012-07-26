class devdns::package {
  package { 'resolvconf':
    ensure => present
  }
  package { 'dnsmasq':
    ensure => present
  }
}
