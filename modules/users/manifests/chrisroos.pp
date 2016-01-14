# Creates the chrisroos user
class users::chrisroos {
  govuk::user { 'chrisroos':
    fullname => 'Chris Roos',
    email    => 'chris.roos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
