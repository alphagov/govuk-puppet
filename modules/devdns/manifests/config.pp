class devdns::config {
  file { '/etc/dnsmasq.d/dev.gov.uk':
    ensure  => present,
    source  => 'puppet:///modules/devdns/dev.gov.uk';
  }
}
