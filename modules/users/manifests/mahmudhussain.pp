# Creates the mahmudhussain user
class users::mahmudhussain {
  govuk_user { 'mahmudhussain':
    fullname => 'Mahmud Hussain',
    email    => 'mahmud.hussain@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2rI72NUdR27YG1uNkH0bZs7RMLMuoxZXFhC5FMv3eV mahmud.hussain@digital.cabinet-office.gov.uk',
  }
}
