# == Class: backup::client
#
# Configures a machine so that it can push backups to the on-site backup
# server.
#
# === Parameters
#
# [*backup_public_key*]
#   The public SSH RSA key used by the backup user.
#   Default: ''
#
class backup::client (
  $backup_public_key = '',
) {

  govuk_user { 'govuk-backup':
    fullname    => 'Backup User',
    email       => 'webops@digital.cabinet-office.gov.uk',
    ssh_key     => "ssh-rsa ${backup_public_key}",
    groups      => [],
    purgegroups => true,
  }

}
