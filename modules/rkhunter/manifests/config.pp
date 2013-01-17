class rkhunter::config {

  file { '/etc/default/rkhunter':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/etc/default/rkhunter',
  }

  file { '/etc/rkhunter.conf.local':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/etc/rkhunter.conf.local',
  }

}
