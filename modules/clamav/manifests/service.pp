class clamav::service {
  service { 'clamav-daemon':
    ensure  => 'running',
  }
}
