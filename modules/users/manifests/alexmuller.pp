# Creates the alexmuller user
class users::alexmuller {
  govuk::user { 'alexmuller':
    fullname => 'Alex Muller',
    email    => 'alex.muller@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
