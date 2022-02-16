# Creates the user beckalelew
class users::beckalelew {
  govuk_user { 'beckalelew':
    fullname => 'Becka Lelew',
    email    => 'becka.lelew@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIR1nueOVbg2PVlCMgAlgNJ+N+2tJcuEvDBMyoGsXgOT becka.lelew@digital.cabinet-office.gov.uk',
  }
}
