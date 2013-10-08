class fail2ban::config {

  file { '/etc/fail2ban/fail2ban.conf':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/fail2ban.conf',
  }

  file { '/etc/fail2ban/fail2ban.local':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/fail2ban.local',
  }

  file { '/etc/fail2ban/jail.conf':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/jail.conf',
  }

  file { '/etc/fail2ban/jail.local':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/jail.local',
  }

}
