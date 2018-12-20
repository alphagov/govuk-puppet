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
# [*ensure*]
#   Specifies if this machine is configure for backup or not. Valid values are:
#   1. 'present' - backup is configure on machine
#   2. 'absent' - backup is not configured on machine
#
class backup::client (
  $backup_public_key = '',
  $ensure = 'present'
) {

  govuk_user { 'govuk-backup':
    fullname    => 'Backup User',
    email       => 'webops@digital.cabinet-office.gov.uk',
    ssh_key     => "ssh-rsa ${backup_public_key}",
    groups      => ['govuk-backup'],
    purgegroups => true,
  }

  group { 'govuk-backup':
    ensure => $ensure,
  }

}
