class nagios {
  include nagios::install, nagios::service
  exec { 'fix_nagios_perms':
    command     => '/bin/chmod -R 755 /etc/nagios3',
    notify      =>  Service['nagios3'],
    refreshonly => true,
  }

  resources { ['nagios_host','nagios_service']:
    purge => true,
  }

  Nagios_host    <<||>> { notify => Service['nagios3'] }
  Nagios_service <<||>> { notify => Exec['fix_nagios_perms'] }
}

