# Creates brendanbutler user
class users::brendanbutler {
  govuk::user { 'brendanbutler':
    fullname => 'Brendan Butler',
    email    => 'brendan.butler@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
