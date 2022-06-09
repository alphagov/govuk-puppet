# Creates the joshpedro user
class users::joshpedro {
  govuk_user { 'joshpedro':
    fullname => 'Joshua Pedro',
    email    => 'joshua.pedro@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNE5Jkpmvly3T46LirI5xtnJR44ZiEPa5JDXfOOUEu4 joshua.pedro@digital.cabinet-office.gov.uk',
  }
}