class nagios {
  include nagios::install, nagios::service
  exec { 'fix_nagios_perms':
    command     => '/bin/chmod -R 755 /etc/nagios3',
    notify      =>  Service['nagios3'],
    refreshonly => true,
  }
  Nagios::Host   <<||>> { notify => Service['nagios3'] }
  Nagios::Check  <<||>> { notify => Service['nagios3'] }
}

