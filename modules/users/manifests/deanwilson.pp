# Creates the deanwilson user
class users::deanwilson {
  govuk::user { 'deanwilson':
    fullname => 'Dean Wilson',
    email    => 'dean.wilson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
