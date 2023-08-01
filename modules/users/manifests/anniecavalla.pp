# Creates the anniecavalla user
class users::anniecavalla {
  govuk_user { 'anniecavalla':
    fullname => 'Annie Cavalla',
    email    => 'annie.cavalla@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrsoo8hap+Ei8ISjfumiAGLapMhk1A0XHLACKKg8tMz annie.cavalla@digital.cabinet-office.gov.uk',
  }
}
