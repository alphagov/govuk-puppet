# Creates the kashifatcha user
class users::kashifatcha {
  govuk_user { 'kashifatcha':
    fullname => 'Kashif Atcha',
    email    => 'kashif.atcha@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMe/WoCnCOcmv06VX8qAhg+H31W+pnWI7eu/uRwlcZc kashif.atcha@digital.cabinet-office.gov.uk',
  }
}