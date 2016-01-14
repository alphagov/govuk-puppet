# Creates the alextorrance user
class users::alextorrance {
  govuk::user { 'alextorrance':
    fullname => 'Alex Torrance',
    email    => 'alex.torrance@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
