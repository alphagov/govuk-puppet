class ganglia::client::service {
  service { 'ganglia-monitor':
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/gmond',
  }
}
