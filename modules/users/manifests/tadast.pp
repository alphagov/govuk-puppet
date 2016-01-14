# Creates the tadast user
class users::tadast {
  govuk::user { 'tadast':
    fullname => 'Tadas Tamosauskas',
    email    => 'tadas.tamosauskas@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
