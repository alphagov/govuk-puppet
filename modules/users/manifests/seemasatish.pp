# Creates the ssatish user
class users::seemasatish {
  govuk::user { 'seemasatish':
    fullname => 'Seema Satish',
    email    => 'seema.satish@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
