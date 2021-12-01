# Creates the davidgisbey user
class users::davidgisbey {
  govuk_user { 'davidgisbey':
    fullname => 'David Gisbey',
    email    => 'david.gisbey@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKjjPnumAMyuz3E3vKGavYaPEoHM9e9mjPyfXqD9UNX david.gisbey@digital.cabinet-office.gov.uk',
  }
}
