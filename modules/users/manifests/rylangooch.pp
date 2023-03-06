# Creates the user rylangooch
class users::rylangooch {
  govuk_user { 'rylangooch':
    fullname => 'Rylan Gooch',
    email    => 'rylan.gooch@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCcUCzC0e7KYulF2q07YwePrE2ocqmOwcMD9Xnhdj5E rylan.gooch@digital.cabinet-office.gov.uk',
  }
}
