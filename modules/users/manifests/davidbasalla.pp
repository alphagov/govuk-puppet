# Creates the davidbasalla user
class users::davidbasalla {
  govuk_user { 'davidbasalla':
    fullname => 'David Basalla',
    email    => 'david.basalla@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
