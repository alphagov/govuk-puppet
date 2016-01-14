# Creates the tommypalmer user
class users::tommypalmer {
  govuk::user { 'tommypalmer':
    fullname => 'Tommy Palmer',
    email    => 'tommy.palmer@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
