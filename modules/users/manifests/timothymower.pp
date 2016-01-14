# Creates the timothymower user
class users::timothymower {
  govuk::user { 'timothymower':
    fullname => 'Timothy Mower',
    email    => 'timothy.mower@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
