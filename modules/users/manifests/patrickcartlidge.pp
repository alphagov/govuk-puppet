# Creates the patrickcartlidge user
class users::patrickcartlidge {
  govuk_user { 'patrickcartlidge':
    fullname => 'Patrick Cartlidge',
    email    => 'patrick.cartlidge@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTzaSh3QhBF+unD1Hc4T6lda19gK3CUj8gEYRL9SOhy patrick.cartlidge@digital.cabinet-office.gov.uk',
  }
}