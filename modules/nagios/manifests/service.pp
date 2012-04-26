class nagios::service {
  service { 'nagios3':
    ensure     => running,
    alias      => 'nagios',
    hasstatus  => true,
    hasrestart => true,
    require    => Class['nagios::install'],
  }
}
