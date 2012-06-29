class nagios {
  include nagios::install, nagios::service
  Nagios::Host   <<||>> { notify => Service['nagios3'] }
  Nagios::Check  <<||>> { notify => Service['nagios3'] }
}

