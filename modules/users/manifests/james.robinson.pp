# Creates the james.robinson user
class users::james.robinson {
  govuk_user { 'james.robinson':
    fullname => 'James Robinson',
    email    => 'james.robinson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIffTKOEB4ZIcF0EUzzEuUl41YgQzPDb18Pm/zLCdY9K james.robinson@digital.cabinet-office.gov.uk',
  }
}
