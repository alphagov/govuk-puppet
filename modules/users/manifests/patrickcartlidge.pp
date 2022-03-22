# Creates the patrickcartlidge user
class users::patrickcartlidge {
  govuk_user { 'patrickcartlidge':
    fullname => 'Patrick Cartlidge',
    email    => 'patrick.cartlidge@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmypQq5y9p1zTW1/yXVRKaY/feGfJe8x+nuDohRGH9x patrick.cartlidge@digital.cabinet-office.gov.uk',
  }
}