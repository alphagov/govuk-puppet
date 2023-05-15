# Creates the dilwoarhussain user
class users::dilwoarhussain {
  govuk_user { 'dilwoarhussain':
    ensure   => absent,
    fullname => 'Dilwoar Hussain',
    email    => 'dilwoar.hussain@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILfSLn+Npn0CmPuRJPLWNy+1kSTB6309/QpdGMo3L9/o dilwoar.hussain@digital.cabinet-office.gov.uk',
  }
}
