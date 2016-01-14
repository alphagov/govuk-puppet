# Creates the gemmaleigh user
class users::gemmaleigh {
  govuk::user { 'gemmaleigh':
    fullname => 'Gemma Leigh',
    email    => 'gemma.leigh@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
