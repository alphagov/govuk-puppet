class fail2ban::package {
  package { 'fail2ban':
    ensure => installed
  }
}
