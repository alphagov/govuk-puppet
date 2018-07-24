# == Class: govuk_pgbouncer
#
# Installs and configures pgbouncer to connect to our Postgres servers.
#
class govuk_pgbouncer() {

  include '::govuk_pgbouncer::config'

  class { '::pgbouncer':
    user          => 'postgres',
    group         => 'postgres',
    databases     => false,
    userlist      => false,
    config_params => {
      auth_type     => 'hba',
      auth_hba_file => '/etc/pgbouncer/pg_hba.conf',
    },
  }
}
