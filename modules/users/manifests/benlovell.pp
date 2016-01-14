# Creates the benlovell user
class users::benlovell {
  govuk::user { 'benlovell':
    fullname => 'Ben Lovell',
    email    => 'ben.lovell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
