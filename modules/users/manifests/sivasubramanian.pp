# Creates the sivasubramanian user
class users::sivasubramanian {
  govuk_user { 'sivasubramanian':
    ensure   => absent,
    fullname => 'Siva Subramanian',
    email    => 'siva.subramanian@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzg5BFA6p4HlZQs0y9jEv7Y+G3bCbRjfCObrKEImn9H siva.subramanian@thoughtworks.com',
  }
}
