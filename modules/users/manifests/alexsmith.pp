# Create the alexsmith user
class users::alexsmith {
  govuk_user { 'alexsmith':
    fullname => 'Alex Smith',
    email    => 'alex.smith@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlJZpQTIFTFuQwLhsMbUPaheLsnEgZqkIX9j+bnd3ZS alex.smith@digital.cabinet-office.gov.uk',
  }
}
