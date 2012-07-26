class devdns::dnsmasq {
  package { 'dnsmasq':
    ensure => present,
    notify => Service['dnsmasq'];
  }
  file { '/etc/dnsmasq.d/dev.gov.uk':
    ensure  => present,
    source  => 'puppet:///modules/devdns/dev.gov.uk',
    require => Package['dnsmasq'],
    notify  => Service['dnsmasq'];
  }
  service { 'dnsmasq':
    ensure  => running,
    require => Package['dnsmasq'];
  }
}
