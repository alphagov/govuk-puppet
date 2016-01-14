# Creates the stuartgale user
class users::stuartgale {
  govuk::user { 'stuartgale':
    fullname => 'Stuart Gale',
    email    => 'stuart.gale@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
