# == Class: govuk_pgbouncer
#
# Installs and configures pgbouncer to connect to our Postgres servers.
#
# === Parameters
#
# [*include_vagrant_user*]
#   Enables the 'vagrant' user with trusted access from localhost to all databases
#   Default: false
#
class govuk_pgbouncer(
  $include_vagrant_user = false,
) {

  include '::govuk_pgbouncer::config'

  if $include_vagrant_user {
    include '::govuk_pgbouncer::vagrant'
  }

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
