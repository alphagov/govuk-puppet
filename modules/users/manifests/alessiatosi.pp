# Creates the alessiatosi user
class users::alessiatosi {
  govuk_user { 'alessiatosi':
    fullname => 'Alessia Tosi',
    email    => 'alessia.tosi@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFcUY5JH8e7IUS9BQwmh9rvrmDm1u3iLVIzIly6sYLw alessia.tosi@digital.cabinet-office.gov.uk',
  }
}