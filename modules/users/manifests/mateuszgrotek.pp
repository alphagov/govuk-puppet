# Creates the mateuszgrotek user
class users::mateuszgrotek {
  govuk_user { 'mateuszgrotek':
    fullname => 'Mateusz Grotek',
    email    => 'mateusz.grotek@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJS+dZATN4SQb8vHLrD+l5HLByIsyrs+I8z8TKj33HIt mateusz.grotek@digital.cabinet-office.gov.uk',
  }
}
