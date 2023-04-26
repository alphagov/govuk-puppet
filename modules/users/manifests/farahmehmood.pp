# Creates the farahmehmood user
class users::farahmehmood {
  govuk_user { 'farahmehmood':
    fullname => 'Farah Mehmood',
    email    => 'farah.mehmood@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZji3ESz+XeCoRRrNrIRSDPYno9+s0RQ/pjI9UpJ5n3 farah.mehmood@digital.cabinet-office.gov.uk',
  }
}