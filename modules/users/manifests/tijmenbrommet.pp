# Creates the tijmenbrommet user
class users::tijmenbrommet {
  govuk::user { 'tijmenbrommet':
    fullname => 'Tijmen Brommet',
    email    => 'tijmen.brommet@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
