class apache2( $port = '8080' ) {

  anchor { 'apache2::begin':
    before => Class['apache2::package'],
    notify => Class['apache2::service'];
  }

  class { 'apache2::package':
    notify => Class['apache2::service'];
  }

  class { 'apache2::config':
    port    => $port,
    require => Class['apache2::package'],
    notify  => Class['apache2::service'];
  }

  class { 'apache2::service': }

  anchor { 'apache2::end':
    require => Class['apache2::service'],
  }

}
