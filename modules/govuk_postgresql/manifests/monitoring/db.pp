# == Define: govuk_postgresql::monitoring::db
#
# Monitor a postgresql database.
#
define govuk_postgresql::monitoring::db () {
  include govuk_postgresql::monitoring
  postgresql::server::database_grant { "${title}-nagios-CONNECT":
    privilege => 'CONNECT',
    db        => $title,
    role      => 'nagios',
  }

}
