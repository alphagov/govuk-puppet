# Creates the user davidmays for David Mays
class users::davidmays {
  govuk_user { 'davidmays':
    fullname => 'David Mays',
    email    => 'david.mays@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7fwYNROcFKo5+T2x+WN33k/K4cQdRLz9BU2bSpl9D1 david.mays@digital.cabinet-office.gov.uk',
    ],
  }
}
