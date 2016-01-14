# Creates the paulhayes user
class users::paulhayes {
  govuk::user { 'paulhayes':
    fullname => 'Paul Hayes',
    email    => 'paul.hayes@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
