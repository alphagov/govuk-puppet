class nagios {
  include nagios::package, nagios::install, nagios::service
  Nagios::Host   <<||>> { notify => Service['nagios3'] }
  Nagios::Check  <<||>> { notify => Service['nagios3'] }
}

