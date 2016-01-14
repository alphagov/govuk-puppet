# Creates the danielroseman user
class users::danielroseman {
  govuk::user { 'danielroseman':
    fullname => 'Daniel Roseman',
    email    => 'daniel.roseman@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
