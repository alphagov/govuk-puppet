# Creates the matmoore user
class users::matmoore {
  govuk::user { 'matmoore':
    fullname => 'Mat Moore',
    email    => 'mat.moore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
