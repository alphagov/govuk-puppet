# Creates the chriswhitehouse user
class users::chriswhitehouse {
  govuk_user { 'chriswhitehouse':
    fullname => 'Chris Whitehouse',
    email    => 'chris.whitehouse@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWx9UP3V8w/dw2eQ/h7fKVpVn/nRJNDC2+N9SSlEqsR chris.whitehouse@digital.cabinet-office.gov.uk',
  }
}