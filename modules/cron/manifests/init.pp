class cron {
  service { 'cron':
    ensure => running,
  }
}
