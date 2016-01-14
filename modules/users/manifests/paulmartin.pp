# Creates the paulmartin user
class users::paulmartin {
  govuk::user { 'paulmartin':
    fullname => 'Paul Martin',
    email    => 'paul.martin@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
