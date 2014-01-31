class icinga::client::service {

  service { 'nagios-nrpe-server':
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '/usr/sbin/nrpe',
  }

}
