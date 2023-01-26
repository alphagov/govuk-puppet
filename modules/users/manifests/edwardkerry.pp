# Creates the user edwardkerry
class users::edwardkerry {
  govuk_user { 'edwardkerry':
    ensure   =>  absent,
    fullname => 'Edward Kerry',
    email    => 'edward.kerry@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID03eorNCOM7OWdZuXosiT7m1/QDtdTL34LJ1JRJJlcs edward.kerry@digital.cabinet-office.gov.uk',
  }
}
