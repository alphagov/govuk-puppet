class govuk_postgresql::monitoring {

  package { 'check-postgres':
    ensure => installed,
  }

  $user = 'nagios'
  $password = 'nagios'
  postgresql::server::role { $user:
    password_hash => postgresql_password($user, $password),
  }

  @@icinga::check { "check_postgresql_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!postgres',
    service_description => 'postgresql not running',
    host_name           => $::fqdn,
  }

  @icinga::nrpe_config { 'check_postgresql_database':
    source => 'puppet:///modules/govuk_postgresql/check_postgresql_database.cfg',
  }

}
