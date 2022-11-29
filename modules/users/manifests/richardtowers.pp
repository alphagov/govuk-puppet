# Creates the user richardtowers
class users::richardtowers {
  govuk_user { 'richardtowers':
    fullname => 'Richard Towers',
    email    => 'richard.towers@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBznmW+hlnSqCeuYFIMSI+hRSQdngjMWWQ9HWipd33sj richard.towers@digital.cabinet-office.gov.uk',
  }
}
