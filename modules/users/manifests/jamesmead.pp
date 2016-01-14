# Creates the jamesmead user
class users::jamesmead {
  govuk::user { 'jamesmead':
    fullname => 'James Mead',
    email    => 'james.mead@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
