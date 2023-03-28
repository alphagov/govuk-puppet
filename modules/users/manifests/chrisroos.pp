# Creates the chrisroos user
class users::chrisroos {
  govuk_user { 'chrisroos':
    fullname => 'Chris Roos',
    email    => 'chris.roos@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJ+Gv6LC/6sd42gzFO+mAhmxE5iujdYapElbkWMcfq8 chris.roos@digital.cabinet-office.gov.uk',
  }
}
