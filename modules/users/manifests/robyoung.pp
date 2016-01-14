# Creates the robyoung user
class users::robyoung {
  govuk::user { 'robyoung':
    fullname => 'Rob Young',
    email    => 'rob.young@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
