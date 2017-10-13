# Creates the timmower user
class users::timmower {
  govuk_user { 'timmower':
    fullname => 'Tim Mower',
    email    => 'tim.mower@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeiPTmKWTt+a+0RXcYejPqYoxePS4e77FVONdf3fGm0 Tim Mower',
  }
}
