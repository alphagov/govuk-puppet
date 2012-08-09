class nagios::client::service {

  service { 'nagios-nrpe-server':
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/nrpe',
  }

}
