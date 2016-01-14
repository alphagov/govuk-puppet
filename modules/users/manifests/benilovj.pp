# Creates the benilovj user
class users::benilovj {
  govuk::user { 'benilovj':
      fullname => 'Jake Benilov',
      email    => 'jake.benilov@digital.cabinet-office.gov.uk',
      ssh_key  => 'ssh-rsa REPLACE ME',
    }
}
