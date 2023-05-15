# Creates the anabotto user
class users::anabotto {
  govuk_user { 'anabotto':
    fullname => 'Ana Botto',
    email    => 'ana.botto@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSOkfPyCqMm4Le+SpPFkL2lIys/tYwStLRWr9Xs6LHN ana.botto@digital.cabinet-office.gov.uk',
  }
}
