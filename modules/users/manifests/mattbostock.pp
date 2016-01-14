# Creates the mattbostock user
class users::mattbostock {
  govuk::user { 'mattbostock':
    fullname => 'Matt Bostock',
    email    => 'matt.bostock@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
