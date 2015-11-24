# == Class govuk_postgresql::monitoring
#
# Sets up the foundations for monitoring PostgreSQL.
#
# === Parameters
#
# [*user*]
#   Username of a monitoring account to create in PostgreSQL
#
# [*password*]
#   The password that you'd like to set for $user
#
class govuk_postgresql::monitoring (
  $user,
  $password,
) {

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
