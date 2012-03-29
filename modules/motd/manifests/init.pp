class motd {
  file { '/etc/update-motd.d/98-fortune':
    ensure => absent
  }

  cron { 'motd':
    ensure  => absent
  }
}
