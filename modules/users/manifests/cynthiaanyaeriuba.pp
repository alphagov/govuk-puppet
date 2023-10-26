# Creates the cynthiaanyaeriuba user
class users::cynthiaanyaeriuba {
  govuk_user { 'cynthiaanyaeriuba':
    fullname => 'Cynthia Anyaeriuba',
    email    => 'cynthia.anyaeriuba@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEcqn1ID4BTxGWXwwntVCa+vtWdkn9c0JeV2YY1y1g0Q cynthia.anyaeriuba@digital.cabinet-office.gov.uk',
  }
}
