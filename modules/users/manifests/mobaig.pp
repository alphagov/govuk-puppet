# Creates the mobaig user
class users::mobaig {
  govuk::user { 'mobaig':
    fullname => 'Mo Baig',
    email    => 'mo.baig@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
