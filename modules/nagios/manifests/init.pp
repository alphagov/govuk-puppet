class nagios {
  include nagios::package, nagios::config, nagios::service
  Nagios::Host   <<||>> { notify => Service['nagios3'] }
  Nagios::Check  <<||>> { notify => Service['nagios3'] }
}

