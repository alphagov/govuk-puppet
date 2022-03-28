# Creates the user nathanharpaul
class users::nathanharpaul {
  govuk_user { 'nathanharpaul':
    ensure   => absent,
    fullname => 'Nathan Harpaul',
    email    => 'nathan.harpaul@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJxAATVVHU0qhrpssg2cQ0Cw9tA6YKedGNFWhgLEjfU nathan.harpaul@digital.cabinet-office.gov.uk',
  }
}
