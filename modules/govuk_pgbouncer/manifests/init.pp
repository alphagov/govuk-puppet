# == Class: govuk_pgbouncer
#
# Installs and configures pgbouncer to connect to our Postgres servers.
#
# === Parameters
#
# [*include_admin_user*]
#   Enables the admin user with trusted access from localhost to all databases
#   Default: true
#
# [*include_vagrant_user*]
#   Enables the 'vagrant' user with trusted access from localhost to all databases
#   Default: false
#
class govuk_pgbouncer(
  $include_admin_user   = true,
  $include_vagrant_user = false,
) {

  include '::govuk_pgbouncer::config'

  if $include_admin_user {
    include '::govuk_pgbouncer::admin'
  }

  if $include_vagrant_user {
    include '::govuk_pgbouncer::vagrant'
  }

  # pgbouncer listens on port 6432
  @ufw::allow { 'pgbouncer-allow-6432-from-any':
    port => 6432,
  }

  class { '::pgbouncer':
    user          => 'postgres',
    group         => 'postgres',
    databases     => false,
    userlist      => false,
    config_params => {
      auth_type         => 'hba',
      auth_hba_file     => '/etc/pgbouncer/pg_hba.conf',
      pool_mode         => 'session',
      default_pool_size => 150,
    },
  }
}
