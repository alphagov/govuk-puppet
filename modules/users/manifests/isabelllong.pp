# Creates the isabelllong user
class users::isabelllong {
  govuk::user { 'isabelllong':
    fullname => 'Isabell Long',
    email    => 'isabell.long@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
