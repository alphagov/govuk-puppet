# Creates the leenagupte user
class users::leenagupte {
  govuk::user { 'leenagupte':
    fullname => 'Leena Gupte',
    email    => 'leena.gupte@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
