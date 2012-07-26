class devdns {
  anchor { 'devdns::begin':
    before => Class['devdns::package'],
    notify => Class['devdns::service'];
  }

  class { 'devdns::package':
    notify => Class['devdns::service'];
  }

  class { 'devdns::config':
    require => Class['devdns::package'],
    notify  => Class['devdns::service'];
  }

  class { 'devdns::service': }

  anchor { 'devdns::end':
    require => Class['devdns::service'],
  }
}
