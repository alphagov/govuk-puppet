# Create the alexwhiteheadsmith user
class users::alexwhiteheadsmith {
  govuk_user { 'alexwhiteheadsmith':
    ensure => absent,
    fullname => 'Alex Whitehead-Smith',
    email    => 'alex.whitehead-smith@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlJZpQTIFTFuQwLhsMbUPaheLsnEgZqkIX9j+bnd3ZS alex.whitehead-smith@digital.cabinet-office.gov.uk',
  }
}
