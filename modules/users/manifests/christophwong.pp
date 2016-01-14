# Creates the christophwong user
class users::christophwong {
  govuk::user { 'christophwong':
    fullname => 'Christoph Wong',
    email    => 'christoph.wong@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
