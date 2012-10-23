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

  anchor { 'rkhunter::end': }

}
