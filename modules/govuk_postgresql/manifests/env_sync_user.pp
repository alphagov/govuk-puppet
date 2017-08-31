# == Class: govuk_postgresql::env_sync_user
#
# Sets up the user and access necessary for the env-sync-and-backup scripts.
#
# === Parameters:
#
# [*password*]
#   Password to set for the env-sync user
#
class govuk_postgresql::env_sync_user (
  $password
) {
  @postgresql::server::role { 'env-sync':
    superuser     => true,
    password_hash => postgresql_password('env-sync', $password),
    tag           => 'govuk_postgresql::server::not_slave',
  }

  postgresql::server::pg_hba_rule { 'local access as env-sync user':
    type        => 'local',
    database    => 'all',
    user        => 'env-sync',
    auth_method => 'md5',
    order       => '001', # necessary to ensure this is before the 'local all all ident' rule.
  }
}
