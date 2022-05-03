# Creates the davidgisbey user
class users::davidgisbey {
  govuk_user { 'davidgisbey':
    fullname => 'David Gisbey',
    email    => 'david.gisbey@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjw5k93HUvD8JPQNhMsjCUFUSQ8TID9UjrVo90H1q4s david.gisbey@digital.cabinet-office.gov.uk',
  }
}
