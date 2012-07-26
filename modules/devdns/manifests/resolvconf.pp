class devdns::resolvconf {
  package { 'resolvconf':
    ensure => present,
    notify => Service['resolvconf'];
  }
  service { 'resolvconf':
    ensure  => running,
    require => Package['resolvconf'];
  }
}
