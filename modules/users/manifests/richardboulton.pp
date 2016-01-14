# Creates the richardboulton user
class users::richardboulton {
  govuk::user { 'richardboulton':
    fullname => 'Richard Boulton',
    email    => 'richard.boulton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
