# Creates the bob user
class users::bob {
  govuk::user { 'bob':
    fullname => 'bob walker',
    email    => 'bob.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
