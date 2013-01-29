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
    notify  => Anchor['rkhunter::end'],
  }

  class { 'rkhunter::monitoring':
    require => Class['rkhunter::config'],
  }

  anchor { 'rkhunter::end':
    require => Class['rkhunter::monitoring'],
  }

}
