# Creates the jackscotti user
class users::jackscotti {
  govuk::user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
