# == Class govuk_postgresql::monitoring
#
# Sets up the foundations for monitoring PostgreSQL.
#
# === Parameters
#
# [*password*]
#   The password that you'd like to set for $user
#
class govuk_postgresql::monitoring (
  $password,
) {

  # This user is granted access to databases in the `govuk_postgresql::monitoring::db` defined type.
  $user = 'nagios'

  package { 'check-postgres':
    ensure => installed,
  }

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
