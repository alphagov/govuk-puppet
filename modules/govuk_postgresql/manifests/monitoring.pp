class govuk_postgresql::monitoring {

  package { 'check-postgres':
    ensure => installed,
  }

  @@icinga::check { "check_postgresql_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!postgres',
    service_description => 'postgresql not running',
    host_name           => $::fqdn,
  }

}
