# Class: rkhunter
#
# Install, configure and periodically run rkhunter on our hosts
#
class rkhunter (
  $ensure = 'present',
){

  anchor { 'rkhunter::begin':
    notify => Class['rkhunter::config'];
  }

  class { 'rkhunter::package':
    ensure  => $ensure,
    require => Anchor['rkhunter::begin'],
    notify  => Class['rkhunter::config'],
  }

  class { 'rkhunter::config':
    ensure  => $ensure,
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
    ensure  => $ensure,
    require => Class['rkhunter::config'],
  }

  anchor { 'rkhunter::end':
    require => Class['rkhunter::monitoring'],
  }

}
