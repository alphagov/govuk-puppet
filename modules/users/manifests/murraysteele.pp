# Creates the murraysteele user
class users::murraysteele {
  govuk::user { 'murraysteele':
    fullname => 'Murray Steele',
    email    => 'murray.steele@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
