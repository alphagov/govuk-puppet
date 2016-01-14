# Creates the daivaughan user
class users::daivaughan {
  govuk::user { 'daivaughan':
    fullname => 'Dai Vaughan',
    email    => 'dai.vaughan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
