# == Class: govuk_postgresql::govuk_backup_user
#
# Sets up the user and access necessary for the env-sync-and-backup scripts.

class govuk_postgresql::govuk_backup_user {
  @postgresql::server::role { 'govuk-backup':
    superuser     => true,
    password_hash => false,
    tag           => 'govuk_postgresql::server::not_slave',
  }

  postgresql::server::pg_hba_rule { 'local access as govuk-backup user':
    type        => 'local',
    database    => 'all',
    user        => 'govuk-backup',
    auth_method => 'ident',
    order       => '001', # necessary to ensure this is before the 'local all all ident' rule.
  }
}
