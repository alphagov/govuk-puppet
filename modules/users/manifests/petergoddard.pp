# Creates the petergoddard user
class users::petergoddard{
  govuk_user { 'petergoddard':
    fullname => 'Peter Goddard',
    email    => 'peter.goddard@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJvdAAnkkbtPXPMPPG0c8o4cqEjbDmKmTZcdtXBuBXV peter.goddard@digital.cabinet-office.gov.uk',
  }
}
