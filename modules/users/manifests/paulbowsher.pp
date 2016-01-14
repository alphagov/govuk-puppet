# Creates the paulbowsher user
class users::paulbowsher {
  govuk::user { 'paulbowsher':
    fullname => 'Paul Bowsher',
    email    => 'paul.bowsher@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
