# Creates the chrispatuzzo user
class users::chrispatuzzo {
  govuk::user { 'chrispatuzzo':
    fullname => 'Chris Patuzzo',
    email    => 'chris.patuzzo@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
