# Creates the user edwardkerry
class users::edwardkerry {
  govuk_user { 'edwardkerry':
    fullname => 'Edward Kerry',
    email    => 'edward.kerry@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIaULpflQlzleFOTh0ZHXyxrKmIJavgm1KenN9OPAdF edwardkerry@gmail.com',
  }
}
