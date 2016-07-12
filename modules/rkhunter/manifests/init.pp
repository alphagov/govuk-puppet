# Class: rkhunter
#
# Install, configure and periodically run rkhunter on our hosts
#
class rkhunter {

  anchor { 'rkhunter::begin':
    notify => Class['rkhunter::config'];
  }

  class { 'rkhunter::package':
    require => Anchor['rkhunter::begin'],
    notify  => Class['rkhunter::config'],
  }

  class { 'rkhunter::config':
    require => Class['rkhunter::package'],
    notify  => [
      Class['rkhunter::update'],
      Anchor['rkhunter::end'],
    ],
  }

  class { 'rkhunter::update':
    require => Class['rkhunter::config'],
  }

  class { 'rkhunter::monitoring':
    require => Class['rkhunter::config'],
  }

  anchor { 'rkhunter::end':
    require => Class['rkhunter::monitoring'],
  }

}
