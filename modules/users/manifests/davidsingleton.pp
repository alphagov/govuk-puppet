# Creates the davidsingleton user
class users::davidsingleton {
  govuk::user { 'davidsingleton':
    fullname => 'David Singleton',
    email    => 'david.singleton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
