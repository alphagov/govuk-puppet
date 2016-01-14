# Creates the tombooth user
class users::tombooth {
  govuk::user { 'tombooth':
    fullname => 'Tom Booth',
    email    => 'tom.booth@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
