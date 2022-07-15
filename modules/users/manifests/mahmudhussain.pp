# Creates the mahmudhussain user
class users::mahmudhussain {
  govuk_user { 'mahmudhussain':
    fullname => 'Mahmud Hussain',
    email    => 'mahmud.hussain@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx/QuKU/aULriOyfNat6HKb5o15e5hPRlj5FX9ouKqk mahmud.hussain@digital.cabinet-office.gov.uk',
  }
}
