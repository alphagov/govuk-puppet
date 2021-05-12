# Creates the user alexandrujurubita
class users::alexandrujurubita {
  govuk_user { 'alexandrujurubita':
    fullname => 'Alexandru Jurubita',
    email    => 'alexandru.jurubita@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRoCYZb0kijHm/03Ca9z1ozJNCu3s94cS/tfDfvDewP alexandru.jurubita@digital.cabinet-office.gov.uk',
  }
}
