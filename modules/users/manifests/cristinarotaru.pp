# Creates the cristinarotaru user
class users::cristinarotaru {
  govuk_user { 'cristinarotaru':
    ensure   => absent,
    fullname => 'Cristina Rotaru',
    email    => 'cristina.rotaru@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBmt64J19ewSIISNNWlyV7C9WUjQNyog6awF6QZ0xNSZ cristina.rotaru@digital.cabinet-office.gov.uk',
  }
}
