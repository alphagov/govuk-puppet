# Creates the jessyyeh user
class users::jessyyeh {
  govuk_user { 'jessyyeh':
    ensure   => absent,
    fullname => 'Jessy Yeh',
    email    => 'jessy.yeh@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXMyN7oCusE0sGGDVvDzm6HwU9+mciIfTUskYp53edM jessy.yeh@digital.cabinet-office.gov.uk',
  }
}
