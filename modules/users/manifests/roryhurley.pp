# Creates the roryhurley user
class users::roryhurley {
  govuk_user { 'roryhurley':
    fullname => 'Rory Hurley',
    email    => 'rory.hurley@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4YHLPZH8g1OLLKw+y1SQcp1xrTM5ITux4yEn8YjgW1 == rory.hurley@digital.cabinet-office.gov.uk',
  }
}