# Creates the catalinailie user
class users::catalinailie {
  govuk_user { 'catalinailie':
    fullname => 'Catalina Ilie',
    email    => 'catalina.ilie@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdxHDS+rOeWFFF0MSXdu0stLLtJ2XSVjnPqU9Egh9jE catalina.ilie@digital.cabinet-office.gov.uk',
  }
}
