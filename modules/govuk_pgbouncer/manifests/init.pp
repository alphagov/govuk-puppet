# == Class: govuk_pgbouncer
#
# Installs and configures pgbouncer to connect to our Postgres servers.
#
class govuk_pgbouncer() {

  class { '::pgbouncer':
    user      => 'postgres',
    group     => 'postgres',
    databases => false,
    userlist  => false,
  }
}
