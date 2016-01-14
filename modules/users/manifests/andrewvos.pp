# Creates the andrewvos user
class users::andrewvos {
  govuk::user { 'andrewvos':
    fullname => 'Andrew Vos',
    email    => 'andrew.vos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
