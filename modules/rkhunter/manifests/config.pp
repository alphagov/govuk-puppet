class rkhunter::config {

  file { '/etc/default/rkhunter':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/rkhunter-defaults',
  }

}
