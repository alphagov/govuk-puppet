class backup::client {

  $backup_pubkey = extlookup('govuk-backup_key', '')

  govuk::user { 'govuk-backup':
    fullname  => 'Backup User',
    email     => 'webops@digital.cabinet-office.gov.uk',
    ssh_key   => "ssh-rsa ${backup_pubkey}",
  }

}
