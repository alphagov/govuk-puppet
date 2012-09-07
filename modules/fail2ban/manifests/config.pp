class nagios::config {

  file { '/etc/fail2ban/fail2ban.conf':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/fail2ban.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/fail2ban/jail.conf':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/jail.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

}
