# Creates the jamiec user
class users::jamiec {
  govuk::user { 'jamiec':
    fullname => 'Jamie Cobbett',
    email    => 'jamie.cobbett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
