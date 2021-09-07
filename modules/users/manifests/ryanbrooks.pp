# Create the ryanbrooks user
class users::ryanbrooks {
  govuk_user { 'ryanbrooks':
    fullname => 'Ryan Brooks',
    email    => 'ryan.brooks@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMvyB1xRc7UdzcDlPvoUGx+LbDbNU1272IjRK9sRUWP ryan.brooks@digital.cabinet-office.gov.uk',
  }
}
