# Creates the marcpomfret user
class users::marcpomfret {
  govuk_user { 'marcpomfret':
    ensure   => absent,
    fullname => 'Marc Pomfret',
    email    => 'marc.pomfret@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHF28IbBpZDTgLtsmW0N55XbIu/gAm8NYKzwBsNx1XAy marc.pomfret@digital.cabinet-office.gov.uk',
  }
}
