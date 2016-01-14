# Creates the leelongmore user
class users::leelongmore {
  govuk::user { 'leelongmore':
    fullname => 'Lee Longmore',
    email    => 'lee.longmore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
