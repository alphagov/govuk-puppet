# Creates the cynthiaanyaeriuba user
class users::cynthiaanyaeriuba {
  govuk_user { 'cynthiaanyaeriuba':
    fullname => 'Cynthia Anyaeriuba',
    email    => 'cynthia.anyaeriuba@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICB8tnRbWKjQAHcOX7DQS35bfSQtAb18MsJDwKEKBqf5 cynthia.anyaeriuba@digital.cabinet-office.gov.uk',
  }
}
