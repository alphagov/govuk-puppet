# Creates the patrickcartlidge user
class users::patrickcartlidge {
  govuk_user { 'patrickcartlidge':
    fullname => 'Patrick Cartlidge',
    email    => 'patrick.cartlidge@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9YWJ+K4Qd7Z3QohW/KVVM5zH3iO+Qwgpv2jkIv2hg+ patrick.cartlidge@digital.cabinet-office.gov.uk',
  }
}