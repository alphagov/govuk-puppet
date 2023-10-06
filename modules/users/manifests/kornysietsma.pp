# Creates the user kornysietsma 
class users::kornysietsma {
  govuk_user { 'kornysietsma':
    ensure   => absent,
    fullname => 'Korny Sietsma',
    email    => 'korny.sietsma@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGnvB7OoYNp/VKsp44hy6OpahuRTxWxZYQgmOJslJ0V korny.sietsma@digital.cabinet-office.gov.uk',
  }
}
