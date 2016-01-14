# Creates the grahampengelly user
class users::grahampengelly {
  govuk::user { 'grahampengelly':
    fullname => 'Graham Pengelly',
    email    => 'graham.pengelly@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
