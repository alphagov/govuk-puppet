# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
