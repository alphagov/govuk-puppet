# Creates the elliot user
class users::elliot {
  govuk::user { 'elliot':
    fullname => 'Elliot Crosby-McCullough',
    email    => 'elliot.crosby-mccullough@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
