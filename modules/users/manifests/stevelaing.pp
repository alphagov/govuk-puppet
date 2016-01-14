# Creates the stevelaing user
class users::stevelaing {
  govuk::user { 'stevelaing':
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
