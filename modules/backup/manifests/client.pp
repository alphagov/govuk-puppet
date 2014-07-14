class backup::client (
  $backup_public_key = '',
) {

  govuk::user { 'govuk-backup':
    fullname    => 'Backup User',
    email       => 'webops@digital.cabinet-office.gov.uk',
    ssh_key     => "ssh-rsa ${backup_public_key}",
    groups      => [],
    purgegroups => true,
  }

}
