# Creates the user bhupindergill
class users::bhupindergill {
  govuk_user { 'bhupindergill':
    ensure   => absent,
    fullname => 'Bhupinder Gill',
    email    => 'bhupinder.gill@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAH2celZRdqiHn5GGkQxZY/7MKOjMq376i7Dv4vkTCFB bhupinder.gill@digital.cabinet-office.gov.uk',
  }
}
