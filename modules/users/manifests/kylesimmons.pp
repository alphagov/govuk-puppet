# Creates the kylesimmons user
class users::kylesimmons {
  govuk_user { 'kylesimmons':
    ensure   => absent,
    fullname => 'Kyle Simmons',
    email    => 'kyle.simmons@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKz99jgxT80k+NOG0WBsO7yurQnPUe7QHnUz+F9AzqIu kyle.simmons@digital.cabinet-office.gov.uk',
  }
}
