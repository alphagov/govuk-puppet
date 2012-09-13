class fail2ban::service {

  service { 'fail2ban':
    ensure => running,
  }

}
