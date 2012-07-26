class devdns {
  class { 'devdns::dnsmasq': }

  class { 'devdns::resolvconf':
    require => Class['devdns::dnsmasq'],
    notify  => Exec['devdns networking restart'];
  }

  exec { 'devdns networking restart':
    command     => '/etc/init.d/networking restart',
    refreshonly => true;
  }
}
