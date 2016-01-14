# Creates the tatianasoukiassian user
class users::tatianasoukiassian {
  govuk::user { 'tatianasoukiassian':
    fullname => 'Tatiana Soukiassian',
    email    => 'tatiana.soukiassian@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
