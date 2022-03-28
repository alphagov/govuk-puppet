# Creates the Rodrigo Hilgenberg Bastos user
class users::rodrigohilgenbergbastos {
  govuk_user { 'rodrigohilgenbergbastos':
    fullname => 'Rodrigo Hilgenberg-Bastos',
    email    => 'rodrigo.hilgenberg-bastos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPG81OnfSzscT2E03HhVRnbkq3cA+0MLL51Y+QGJkOwl rodrigo.hilgenberg-bastos@digital.cabinet-office.gov.uk',
  }
}
