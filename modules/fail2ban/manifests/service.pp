class fail2ban::service {

  service { 'fail2ban':
    ensure     => running,
    require    => Class['fail2ban::package']
  }

  File['/etc/fail2ban/fail2ban.conf'] ~> Service['fail2ban']
  File['/etc/fail2ban/jail.conf']     ~> Service['fail2ban']
}
