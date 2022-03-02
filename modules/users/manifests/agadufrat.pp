# Creates the user agadufrat
class users::agadufrat {
  govuk_user { 'agadufrat':
    fullname => 'Aga Dufrat',
    email    => 'aga.dufrat@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGxDwiHOHzdRjwgvd1bm4r8RQhZvIg4u8uM4/6ollnA aga.dufrat@digital.cabinet-office.gov.uk',
  }
}
