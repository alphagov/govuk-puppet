# Creates the mattbostock user
class users::mathildathompson {
  govuk::user { 'mathildathompson':
    fullname => 'Mathilda Thompson',
    email    => 'mathilda.thompson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
