class unattended_upgrades {

  package { 'unattended-upgrades':
    ensure => installed,
  }

  file { '/etc/apt/apt.conf.d/10periodic':
    ensure  => present,
    source  => 'puppet:///modules/unattended_upgrades/10periodic',
    require => Package['unattended-upgrades'],
  }

  file { '/etc/apt/apt.conf.d/50unattended-upgrades':
    ensure  => present,
    source  => 'puppet:///modules/unattended_upgrades/50unattended-upgrades',
    require => Package['unattended-upgrades'],
  }

}
