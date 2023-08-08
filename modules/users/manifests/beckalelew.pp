# Creates the user beckalelew
class users::beckalelew {
  govuk_user { 'beckalelew':
    fullname => 'Becka Lelew',
    email    => 'becka.lelew@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUzfoH86Pby61x10zbeYEEfupbDslZQHSbultbZWssn becka.lelew@digital.cabinet-office.gov.uk',
    ensure   => absent,
  }
}
