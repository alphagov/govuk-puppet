# == Class: nscd
class nscd {

  anchor { 'nscd::begin':
    notify => Class['nscd::service'];
  }

  class { 'nscd::package':
    require => Anchor['nscd::begin'],
    notify  => Class['nscd::service'];
  }

  class { 'nscd::config':
    require => Class['nscd::package'],
    notify  => Class['nscd::service'];
  }

  class { 'nscd::service': }

  anchor { 'nscd::end':
    require => Class['nscd::service'],
  }

}
